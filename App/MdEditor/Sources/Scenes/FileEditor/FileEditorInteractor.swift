//
//  AboutInteractor.swift
//  MdEditor
//
//  Created by Aleksey Efimov on 03.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

protocol IFileEditorInteractor: AnyObject {
	/// Событие на предоставление данных из файла.
	func fetchData()
}

final class FileEditorInteractor: IFileEditorInteractor {

	// MARK: - Dependencies

	private var presenter: IFileEditorPresenter?
	private var fileStorage: IStorageService?

	// MARK: - Private properties

	private var url: URL

	// MARK: - Initialization

	init(presenter: IFileEditorPresenter, fileStorage: IStorageService, url: URL) {
		self.presenter = presenter
		self.fileStorage = fileStorage
		self.url = url
	}

	// MARK: - Public methods

	func fetchData() {
		let title = url.lastPathComponent
		updateTitle(title: title)
		Task {
			let title = url.lastPathComponent
			let result = await fileStorage?.loadFileBody(url: url) ?? ""
			await updateUI(with: title, fileData: result)
		}
	}
	
	private func updateTitle(title: String) {
		presenter?.presentTitle(responce: FileEditorModel.Response(title: title, fileData: ""))
	}

	@MainActor
	func updateUI(with title: String, fileData: String) {
		presenter?.present(responce: FileEditorModel.Response(
			title: title,
			fileData: fileData
		))
	}
}
