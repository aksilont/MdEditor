//
//  AboutPresenter.swift
//  MdEditor
//
//  Created by Aleksey Efimov on 03.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

protocol IFileEditorPresenter {
	func present(responce: FileEditorModel.Response)
}

final class FileEditorPresenter: IFileEditorPresenter {
	
	// MARK: - Dependencies
	
	private weak var viewController: IFileEditorViewController?
	
	// MARK: - Initialization
	
	init(viewController: IFileEditorViewController?) {
		self.viewController = viewController
	}
	
	// MARK: - Public methods
	
	func present(responce: FileEditorModel.Response) {
		let title = responce.title
		let fileData = responce.fileData
		viewController?.render(viewModel: FileEditorModel.ViewModel(
			title: title,
			fileData: fileData
		))
	}
}
