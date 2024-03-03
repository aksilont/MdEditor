//
//  EditorCoordinator.swift
//  MdEditor
//
//  Created by Константин Натаров on 01.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

final class EditorCoordinator: BaseCoordinator {
	// MARK: - Dependencies
	private let navigationController: UINavigationController
	private let storage: IStorageService

	// MARK: - Initialization
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
		storage = FileStorageService(
			fileManager: FileManager.default,
			defaultURL: ResourcesBundle.defaultUrls,
			ext: [ResourcesBundle.extMD]
		)
	}

	// MARK: - Internal methods
	override func start() {
		showStartScreenScene()
	}
}

// MARK: - Private methods
private extension EditorCoordinator {
	func showMessage(message: String) {
		let alert = UIAlertController(
			title: L10n.Message.text,
			message: message,
			preferredStyle: .alert
		)
		let action = UIAlertAction(title: L10n.Ok.text, style: .default)
		alert.addAction(action)

		navigationController.present(alert, animated: true, completion: nil)
	}

	func showStartScreenScene() {
		let recentFileManager = RecentFileManager(key: UserDefaults.Keys.recentFilesKey.rawValue)
		let (viewController, interactor) = StartScreenAssembler().assembly(
			recentFileManager: recentFileManager
		)
		interactor.delegate = self

		navigationController.setViewControllers([viewController], animated: true)
	}

	func showAboutScene() {
		let viewController = AboutScreenAssembler().assembly(storage: storage)
		navigationController.pushViewController(viewController, animated: true)
	}

	func showFileEditorScene(file: FileSystemEntity) {
		let viewController = FileEditorAssembler().assembly(
			storage: storage,
			file: file,
			editable: true
		)

		navigationController.pushViewController(viewController, animated: true)
	}

	func runFileListFlow() {
		let topViewController = navigationController.topViewController
		let coordinator = FileListCoordinator(
			navigationController: navigationController,
			topViewController: topViewController,
			storage: storage
		)
		addDependency(coordinator)

		coordinator.finishFlow = { [weak self, weak coordinator] in
			guard let self = self else { return }
			if let topViewController = topViewController {
				self.navigationController.popToViewController(topViewController, animated: true)
			} else {
				self.navigationController.popToRootViewController(animated: true)
			}
			if let coordinator = coordinator {
				self.removeDependency(coordinator)
			}
		}

		coordinator.start()
	}
}

// MARK: - IStartScreenDelegate
extension EditorCoordinator: IStartScreenDelegate {
	func showAbout() {
		showAboutScene()
	}
	
	func openFileList() {
		runFileListFlow()
	}
	
	func newFile() {
		showMessage(message: "New file")
	}
	
	func openFile(file: FileSystemEntity) {
		showFileEditorScene(file: file)
	}
}
