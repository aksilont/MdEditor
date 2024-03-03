//
//  FileEditorAssembler.swift
//  MdEditor
//
//  Created by Aleksey Efimov on 03.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

final class FileEditorAssembler {
	func assembly(storage: IStorageService, file: FileSystemEntity, editable: Bool) -> FileEditorViewController {
		let viewController = FileEditorViewController(editable: editable)
		let presenter = FileEditorPresenter(viewController: viewController)
		let interactor = FileEditorInteractor(presenter: presenter, storage: storage, file: file)
		viewController.interactor = interactor
		
		return viewController
	}
}
