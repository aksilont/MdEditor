//
//  PdfPreviewViewController.swift
//  MdEditor
//
//  Created by Aksilont on 11.03.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit
import PDFKit

protocol IPdfPreviewViewController: AnyObject {
	func render(with viewModel: PdfPreviewModel.ViewModel)
}

final class PdfPreviewViewController: UIViewController {
	// MARK: - Dependencies
	var interactor: IPdfPreviewInteracotor?

	// MARK: - Private properties
	private lazy var pdfView = makePdfView()
	private lazy var activityIndicator = UIActivityIndicatorView(style: .large)

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()

		interactor?.fetchData()
	}

	// MARK: - Private methods
	private func setupView() {
		view.backgroundColor = Theme.backgroundColor

		activityIndicator.center = view.center
		activityIndicator.startAnimating()
		view.addSubview(activityIndicator)
	}

	private func makePdfView() -> PDFView {
		let pdfView = PDFView()
		pdfView.autoScales = true
		pdfView.pageBreakMargins = Sizes.PdfPreview.pageBreakMargins

		pdfView.frame = view.frame
		pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		return pdfView
	}
}

// MARK: - IPdfPreviewViewController
extension PdfPreviewViewController: IPdfPreviewViewController {
	func render(with viewModel: PdfPreviewModel.ViewModel) {
		switch viewModel {
		case .title(let value):
			title = value
		case .data(let data):
			activityIndicator.stopAnimating()
			activityIndicator.removeFromSuperview()

			pdfView.document = PDFDocument(data: data)
			view.addSubview(pdfView)
		}
	}
}
