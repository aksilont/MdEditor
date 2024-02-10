//
//  FileListCoordinator.swift
//  MdEditor
//
//  Created by Aksilont on 03.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

final class FileListCoordinator: BaseCoordinator {
	// MARK: - Dependencies
	private let navigationController: UINavigationController

	// MARK: - Private properties
	private let urls: [URL]
	private let storage: IStorageService

	// MARK: - Public properties
	var selectFile: ((URL) -> Void)?

	// MARK: - Initialization
	init(navigationController: UINavigationController, urls: [URL], storage: IStorageService) {
		self.navigationController = navigationController
		self.urls = urls
		self.storage = storage
	}

	// MARK: - Public methods
	override func start() {
		showFileListScene(urls: urls)
	}
}

// MARK: - Private methods
private extension FileListCoordinator {
	func showFileListScene(urls: [URL]) {
		let assembler = FileListAssembler()
		let viewController = assembler.assembly(
			urls: urls,
			storage: storage
		) { [weak self] url in
			self?.selectFile?(url)
		}
		navigationController.pushViewController(viewController, animated: true)
	}
}
