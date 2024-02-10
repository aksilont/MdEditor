//
//  FileListInteractor.swift
//  MdEditor
//
//  Created by Aksilont on 31.01.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

protocol IFileListInteractor {
	/// Событие на предоставление информации для списка файлов.
	/// - Parameter urls: Адреса файлов
	func fetchData(urls: [URL])

	/// Событие, что файл бы выбран
	/// - Parameter request: Запрос, содержащий информацию о выбранном файле.
	func didFileSelected(request: FileListModel.Request)
}

final class FileListInteractor: IFileListInteractor {
	// MARK: - Dependencies
	private var presenter: IFileListPresenter
	private var storage: IStorageService

	// MARK: - Initialization
	init(presenter: IFileListPresenter, storage: IStorageService) {
		self.presenter = presenter
		self.storage = storage
	}

	// MARK: - Public methods
	func fetchData(urls: [URL]) {
		Task {
			let result = await storage.fetchData(urls: urls)
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
		let responseFiles = files.map { file in
			FileListModel.FileViewModel(
				url: file.url,
				name: file.name,
				isDir: file.isDir,
				description: file.getFormattedAttributes()
			)
		}
		let response = FileListModel.Response(data: responseFiles)
		presenter.present(response: response)
	}

	func didFileSelected(request: FileListModel.Request) {
		presenter.didFileSelected(response: request.url)
	}
}
