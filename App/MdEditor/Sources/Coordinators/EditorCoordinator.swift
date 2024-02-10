//
//  EditorCoordinator.swift
//  MdEditor
//
//  Created by Константин Натаров on 01.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

final class EditorCoordinator: ICoordinator {

	// MARK: - Dependencies

	private let navigationController: UINavigationController

	var openFileListSceen: (() -> Void)?
	var openAboutSceen: (() -> Void)?

	// MARK: - Initialization

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	// MARK: - Internal methods

	func start() {
		showStartScreen()
	}

	// MARK: - Private methods

	private func showStartScreen() {
		let assembler = StartScreenAssembler()
		let viewController = assembler.assembly(
			openFileClosure: openFileListSceen,
			openAboutClosure: openAboutSceen
		)
		navigationController.pushViewController(viewController, animated: true)
	}
}
