//
//  AboutInteractor.swift
//  MdEditor
//
//  Created by Aleksey Efimov on 03.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation
import MarkdownPackage

protocol IFileEditorInteractor: AnyObject {
	/// Событие на предоставление данных из файла.
	func fetchData()
}

final class FileEditorInteractor: IFileEditorInteractor {
	// MARK: - Dependencies
	private var presenter: IFileEditorPresenter?
	private var storage: IStorageService
	
	// MARK: - Private properties
	private var file: FileSystemEntity
	
	// MARK: - Initialization
	init(presenter: IFileEditorPresenter, storage: IStorageService, file: FileSystemEntity) {
		self.presenter = presenter
		self.storage = storage
		self.file = file
	}
	
	// MARK: - Public methods
	func fetchData() {
		let title = file.name
		let result = file.loadFileBody()
		RecentFileManager(key: UserDefaults.Keys.recentFilesKey.rawValue).addToRecentFiles(file)
		updateUI(with: title, fileData: result)
	}

	func updateUI(with title: String, fileData: String) {
		let attrributedText = MarkdownToAttributedTextConverter().convert(markdownText: fileData)
		presenter?.present(responce: FileEditorModel.Response(title: title, fileData: attrributedText))
	}
}
