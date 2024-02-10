//
//  StartScreenPresenter.swift
//  MdEditor
//
//  Created by Константин Натаров on 01.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

protocol IStartScreenPresenter {
	func present(response: StartScreenModel.Response)
	func openFileList()
	func openAbout()
}

typealias OpenFileListClosure = () -> Void
typealias OpenAboutClosure = () -> Void

final class StartScreenPresenter: IStartScreenPresenter {

	// MARK: - Dependencies

	private weak var viewController: IStartScreenViewController?

	private var openFileListClosure: OpenFileListClosure?
	private var openAboutClosure: OpenAboutClosure?

	// MARK: - Initialization
	init(
		viewController: IStartScreenViewController?,
		openFileClosure: OpenFileListClosure?,
		openAboutClosure: OpenAboutClosure?
	) {
		self.viewController = viewController
		self.openFileListClosure = openFileClosure
		self.openAboutClosure = openAboutClosure
	}

	// MARK: - Public methods

	func present(response: StartScreenModel.Response) {
		let docs = response.docs
		let viewModel = StartScreenModel.ViewModel(documents: docs)

		viewController?.render(with: viewModel)
	}

	func openFileList() {
		openFileListClosure?()
	}

	func openAbout() {
		openAboutClosure?()
	}

	// MARK: - Private methods

}
