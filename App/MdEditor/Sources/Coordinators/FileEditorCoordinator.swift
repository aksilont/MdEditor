//
//  FileEditorCoordinator.swift
//  MdEditor
//
//  Created by Aleksey Efimov on 03.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

final class FileEditorCoordinator: ICoordinator {
	
	// MARK: - Dependencies
	
	private let navigationController: UINavigationController
	private let fileStorage: IStorageService

	// MARK: - Private properties
	
	private let url: URL
	private let editable: Bool
	
	// MARK: - Initialization
	
	init(navigationController: UINavigationController, fileStorage: IStorageService, url: URL, editable: Bool) {
		self.navigationController = navigationController
		self.fileStorage = fileStorage
		self.url = url
		self.editable = editable
	}
	
	// MARK: - Internal methods
	
	func start() {
		showFileEdilorScene()
	}
	
	// MARK: - Private methods
	
	private func showFileEdilorScene() {
		let assembler = FileEditorAssembler()
		let viewController = assembler.assembly(fileStorage: fileStorage, url: url, editable: editable)
		navigationController.pushViewController(viewController, animated: true)
	}
}
