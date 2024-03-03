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
}

final class FileListPresenter: IFileListPresenter {
	// MARK: - Dependencies
	private weak var viewController: IFileListViewController?

	// MARK: - Initialization
	init(viewController: IFileListViewController) {
		self.viewController = viewController
	}

	// MARK: - Public methods
	func present(response: FileListModel.Response) {
		let fileViewModels = response.data.map {
			FileListModel.ViewModel.FileViewModel(
				name: $0.name,
				isDir: $0.isDir,
				description: getFormattedAttributes(file: $0)
			)
		}

		let viewModel = FileListModel.ViewModel(
			title: response.currentFile?.name ?? "/",
			data: fileViewModels
		)
		viewController?.render(viewModel: viewModel)
	}
}

extension FileListPresenter {
	func getFormattedSize(with size: UInt64) -> String {
		var convertedValue = Double(size)
		var multiplyFactor = 0
		let tokens = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
		while convertedValue > 1024 {
			convertedValue /= 1024
			multiplyFactor += 1
		}
		return String(format: multiplyFactor == 0 ? "%.0f %@" : "%4.2f %@", convertedValue, tokens[multiplyFactor])
	}

	func getFormattedAttributes(file: FileSystemEntity) -> String {
		let formattedSize = getFormattedSize(with: file.size)

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = L10n.FileList.dateFormat

		if file.isDir {
			return "\(dateFormatter.string(from: file.modificationDate)) | <dir>"
		} else {
			return "\"\(file.ext)\" – \(dateFormatter.string(from: file.modificationDate)) | \(formattedSize)"
		}
	}
}
