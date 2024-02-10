//
//  StartScreenInteractor.swift
//  MdEditor
//
//  Created by Константин Натаров on 01.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

protocol IStartScreenInteractor {
	func fetchData()
	func openFileList()
	func openAbout()
}

final class StartScreenInteractor: IStartScreenInteractor {

	// MARK: - Dependencies

	private var presenter: IStartScreenPresenter?
	private var fileStorage: IFileStorage

	// MARK: - Initialization

	init(presenter: IStartScreenPresenter?, fileStorage: IFileStorage) {
		self.presenter = presenter
		self.fileStorage = fileStorage
	}

	// MARK: - Public methods

	func fetchData() {
		let docsFromStorage = fileStorage.getAllDocs()
		let documents = docsFromStorage.map { document in
			StartScreenModel.Document(
				fileName: document.fileName,
				preview: ImageData(data: document.preview?.pngData())
			)
		}
		let response = StartScreenModel.Response(docs: documents)
		presenter?.present(response: response)
	}

	func openFileList() {
		presenter?.openFileList()
	}

	func openAbout() {
		presenter?.openAbout()
	}
}
