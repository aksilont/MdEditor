//
//  PdfPreviewAssembler.swift
//  MdEditor
//
//  Created by Aksilont on 11.03.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit
import MarkdownPackage

final class PdfPreviewAssembler {
	func assembly(file: FileSystemEntity, converter: any IMarkdownConverter) -> UIViewController {
		let viewController = PdfPreviewViewController()
		let presenter = PdfPreviewPresenter(viewController: viewController)
		let interactor = PdfPreviewInteracotor(presenter: presenter, converter: converter, file: file)
		viewController.interactor = interactor

		return viewController
	}
}
