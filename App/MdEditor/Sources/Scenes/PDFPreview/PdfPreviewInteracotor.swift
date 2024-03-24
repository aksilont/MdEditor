//
//  PdfPreviewInteracotor.swift
//  MdEditor
//
//  Created by Aksilont on 13.03.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation
import MarkdownPackage

protocol IPdfPreviewInteracotor {
	func fetchData()
}

final class PdfPreviewInteracotor: IPdfPreviewInteracotor {
	// MARK: - Dependencies
	private var presenter: IPdfPreviewPresenter?
	private var converter: any IMarkdownConverter

	// MARK: - Private properties
	private let file: FileSystemEntity

	// MARK: - Initialization
	internal init(
		presenter: IPdfPreviewPresenter,
		converter: any IMarkdownConverter,
		file: FileSystemEntity
	) {
		self.presenter = presenter
		self.converter = converter
		self.file = file
	}

	// MARK: - Public methods
	func fetchData() {
		// Изменение заголовка отправим сразу в главном потоке
		presenter?.present(response: .title(file.name))

		let text = file.loadFileBody()
		converter.convert(markdownText: text) { [weak self] data in
			guard let data = data as? Data else { return }
			self?.presenter?.present(response: .data(data))
		}
	}
}
