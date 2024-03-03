//
//  StartScreenInteractor.swift
//  MdEditor
//
//  Created by Константин Натаров on 01.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

protocol IStartScreenDelegate: AnyObject {
	func showAbout()
	func openFileList()
	func newFile()
	func openFile(file: FileSystemEntity)
}

protocol IStartScreenInteractor {
	func fetchData()
	func performAction(request: StartScreenModel.Request)
}

final class StartScreenInteractor: IStartScreenInteractor {
	// MARK: - Public properties
	weak var delegate: IStartScreenDelegate?

	// MARK: - Dependencies
	private var presenter: IStartScreenPresenter?
	private var recentFileManager: IRecentFileManager

	// MARK: - Initialization
	init(presenter: IStartScreenPresenter?, recentFileManager: IRecentFileManager) {
		self.presenter = presenter
		self.recentFileManager = recentFileManager
	}

	// MARK: - Public methods
	func fetchData() {
		let result = recentFileManager.getRecentFiles()
		updateUI(with: result)
	}

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

	func performAction(request: StartScreenModel.Request) {
		switch request {
		case .creaeteNewFile:
			delegate?.newFile()
		case .openFileList:
			delegate?.openFileList()
		case .showAbout:
			delegate?.showAbout()
		case .recentFileSelected(let indexPath):
			let recentFiles = recentFileManager.getRecentFiles()
			let recentFile = recentFiles[min(indexPath.row, recentFiles.count - 1)]
			delegate?.openFile(file: recentFile)
		case .deleteRecentFile(let indexPath):
			let recentFiles = recentFileManager.getRecentFiles()
			let recentFile = recentFiles[min(indexPath.row, recentFiles.count - 1)]
			recentFileManager.deleteRecentFile(recentFile)
			fetchData()
		}
	}
}
