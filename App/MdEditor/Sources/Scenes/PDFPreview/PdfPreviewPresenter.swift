//
//  PdfPreviewPresenter.swift
//  MdEditor
//
//  Created by Aksilont on 13.03.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

protocol IPdfPreviewPresenter {
	func present(response: PdfPreviewModel.Response)
}

final class PdfPreviewPresenter: IPdfPreviewPresenter {
	// MARK: - Dependencies
	private weak var viewController: IPdfPreviewViewController?

	// MARK: - Initialization
	init(viewController: IPdfPreviewViewController?) {
		self.viewController = viewController
	}

	// MARK: - Public methods
	func present(response: PdfPreviewModel.Response) {
		switch response {
		case .title(let string):
			viewController?.render(with: .title(string))
		case .data(let data):
			viewController?.render(with: .data(data))
		}
	}
}
