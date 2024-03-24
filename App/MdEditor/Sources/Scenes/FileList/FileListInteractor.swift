//
//  FileListInteractor.swift
//  MdEditor
//
//  Created by Aksilont on 31.01.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

/// Делегат по управлению открытием папки и файла. Реализован должен быть в координаторе.
protocol IFileListDelegate: AnyObject {
	/// Открыть выбранную папке.
	/// - Parameter file: Ссылка на папку.
	func openFolder(file: FileSystemEntity)

	/// Открыть выбранный файл.
	/// - Parameter file: Ссылка на файл.
	func openFile(file: FileSystemEntity)

	func goHome()
}

protocol IFileListInteractor {
	/// Событие на предоставление информации для списка файлов.
	/// - Parameter urls: Адреса файлов
	func fetchData()

	/// Событие, что файл бы выбран
	/// - Parameter request: Запрос, содержащий информацию о действии пользователя
	func performAction(request: FileListModel.Request)
}

final class FileListInteractor: IFileListInteractor {
	// MARK: - Public properties
	weak var delegate: IFileListDelegate?

	// MARK: - Dependencies
	private var presenter: IFileListPresenter
	private var storage: IStorageService

	// MARK: - Private properties
	private var currentFile: FileSystemEntity?
	private var files: [FileSystemEntity] = []

	// MARK: - Initialization
	init(presenter: IFileListPresenter, storage: IStorageService, file: FileSystemEntity?) {
		self.presenter = presenter
		self.storage = storage
		self.currentFile = file
	}

	// MARK: - Public methods
	func fetchData() {
		// Обновление заголовка сразу в главном потоке
		updateTitle(currentFile?.name ?? "/")
		// Получение файлов асинхронно
		Task {
			let result = await storage.fetchData(of: currentFile?.url)
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
		self.files = files
		let response = FileListModel.Response(currentFile: currentFile, data: files)
		presenter.present(response: response)
	}

	func updateTitle(_ title: String) {
		let response = FileListModel.Response(currentFile: currentFile, data: [])
		presenter.present(response: response)
	}

	func performAction(request: FileListModel.Request) {
		switch request {
		case .fileSelected(let indexPath):
			let selectedFile = files[min(indexPath.row, files.count - 1)]
			if selectedFile.isDir {
				delegate?.openFolder(file: selectedFile)
			} else {
				delegate?.openFile(file: selectedFile)
			}
		case .goHome:
			delegate?.goHome()
		}
	}
}
