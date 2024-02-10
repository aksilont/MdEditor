//
//  FileListPresenter.swift
//  MdEditor
//
//  Created by Aksilont on 31.01.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

protocol IFileListPresenter {
	/// Отображение экрана со списком заданий.
	/// - Parameter response: Подготовленные к отображению данные.
	func present(response: FileListModel.Response)

	func didFileSelected(response: URL)
}

typealias FileListClosure = (URL) -> Void

final class FileListPresenter: IFileListPresenter {
	// MARK: - Dependencies
	private weak var viewController: IFileListViewController?
	private var openFileClosure: FileListClosure?

	// MARK: - Initialization
	init(viewController: IFileListViewController, openFileClosure: FileListClosure?) {
		self.viewController = viewController
		self.openFileClosure = openFileClosure
	}

	// MARK: - Public methods
	func present(response: FileListModel.Response) {
		let viewModel = FileListModel.ViewModel(data: response.data)
		viewController?.render(viewModel: viewModel)
	}

	func didFileSelected(response: URL) {
		openFileClosure?(response)
	}
}
