//
//  StartScreenAssembler.swift
//  MdEditor
//
//  Created by Константин Натаров on 01.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

final class StartScreenAssembler {

	func assembly(
		openFileClosure: OpenFileListClosure?,
		openAboutClosure: OpenAboutClosure?
	) -> StartScreenViewController {
		let fileStorage = FileStorageService()
		let viewController = StartScreenViewController()
		let presenter = StartScreenPresenter(
			viewController: viewController,
			openFileClosure: openFileClosure,
			openAboutClosure: openAboutClosure
		)
		let interactor = StartScreenInteractor(presenter: presenter, fileStorage: fileStorage)

		viewController.interactor = interactor

		return viewController
	}
}
