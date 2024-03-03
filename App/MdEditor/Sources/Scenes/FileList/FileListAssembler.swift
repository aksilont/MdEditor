//
//  FileListAssembler.swift
//  MdEditor
//
//  Created by Aksilont on 31.01.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

final class FileListAssembler {
	/// Сборка модуля открытия файла
	/// - Returns: `(FileListViewController, FileListInteractor)`
	func assembly(
		storage: IStorageService,
		file: FileSystemEntity?
	) -> (FileListViewController, FileListInteractor) {
		let viewController = FileListViewController()
		let presenter = FileListPresenter(viewController: viewController)
		let interactor = FileListInteractor(
			presenter: presenter,
			storage: storage,
			file: file
		)

		viewController.interactor = interactor

		return (viewController, interactor)
	}
}
