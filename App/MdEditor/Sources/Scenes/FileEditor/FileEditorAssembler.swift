//
//  FileEditorAssembler.swift
//  MdEditor
//
//  Created by Aleksey Efimov on 03.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

final class FileEditorAssembler {

	func assembly(fileStorage: IStorageService, url: URL, editable: Bool) -> FileEditorViewController {
		let viewController = FileEditorViewController(editable: editable)
		let presenter = FileEditorPresenter(viewController: viewController)
		let interactor = FileEditorInteractor(presenter: presenter, fileStorage: fileStorage, url: url)
		viewController.interactor = interactor
		
		return viewController
	}
}
