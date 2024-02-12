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
	private var fileStorage: IStorageService

	// MARK: - Initialization

	init(presenter: IStartScreenPresenter?, fileStorage: IStorageService) {
		self.presenter = presenter
		self.fileStorage = fileStorage
	}

	// MARK: - Public methods

	func fetchData() {
		Task {
			let urls = ResourcesBundle.defaultsUrls
			let result = await fileStorage.fetchRecent(count: 10, with: urls)
			switch result {
			case .success(let files):
				await updateUI(with: files)
			case .failure(let error):
				fatalError(error.localizedDescription)
			}
		}
	}

	@MainActor
	func updateUI(with files: [FileSystemEntity]) {
		let documents = files.map { document in
			StartScreenModel.Document(
				fileName: document.name, 
				content: document.loadFileBody()
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
