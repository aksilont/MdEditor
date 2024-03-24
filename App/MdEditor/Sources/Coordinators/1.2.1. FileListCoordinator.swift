//
//  FileListCoordinator.swift
//  MdEditor
//
//  Created by Aksilont on 03.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit
import MarkdownPackage

protocol IFileListCoordinator: ICoordinator {
	/// Метод для завершении сценария
	var finishFlow: (() -> Void)? { get set }
}

final class FileListCoordinator: BaseCoordinator, IFileListCoordinator {
	// MARK: - Dependencies
	private let navigationController: UINavigationController
	private let topViewController: UIViewController?

	// MARK: - Private properties
	private let storage: IStorageService

	// MARK: - Public properties
	var finishFlow: (() -> Void)?

	// MARK: - Initialization
	init(
		navigationController: UINavigationController,
		topViewController: UIViewController?,
		storage: IStorageService
	) {
		self.navigationController = navigationController
		self.topViewController = topViewController
		self.storage = storage

		super.init()

		navigationController.delegate = self
	}

	// MARK: - Public methods
	override func start() {
		showFileListScene()
	}
}

// MARK: - Private methods
private extension FileListCoordinator {
	func showFileListScene(file: FileSystemEntity? = nil) {
		let (viewController, interactor) = FileListAssembler().assembly(
			storage: storage,
			file: file
		)
		interactor.delegate = self

		navigationController.pushViewController(viewController, animated: true)
	}

	func showFileEditorScene(file: FileSystemEntity) {
		let (viewController, interactor) = FileEditorAssembler().assembly(
			storage: storage,
			file: file,
			editable: true
		)
		interactor.delegate = self

		navigationController.pushViewController(viewController, animated: true)
	}

	func showPdfPreviewScene(file: FileSystemEntity, author: String) {
		let converter = MainQueueDispatchConverterDecorator<Data>(
			MarkdownToPdfConverter(pdfAuthor: author, pdfTitle: file.name)
		)
		let viewController = PdfPreviewAssembler().assembly(file: file, converter: converter)
		navigationController.pushViewController(viewController, animated: true)
	}
}

// MARK: - UINavigationControllerDelegate
extension FileListCoordinator: UINavigationControllerDelegate {
	func navigationController(
		_ navigationController: UINavigationController,
		didShow viewController: UIViewController,
		animated: Bool
	) {
		if viewController === topViewController {
			finishFlow?()
		}
	}
}

// MARK: - IFileListDelegate
extension FileListCoordinator: IFileListDelegate {
	func openFolder(file: FileSystemEntity) {
		showFileListScene(file: file)
	}
	
	func openFile(file: FileSystemEntity) {
		showFileEditorScene(file: file)
	}

	func goHome() {
		navigationController.popToRootViewController(animated: true)
	}
}

// MARK: - IFileEditorDelegate
extension FileListCoordinator: IFileEditorDelegate {
	func exportToPDF(file: FileSystemEntity, author: String) {
		showPdfPreviewScene(file: file, author: author)
	}
}
