//
//  DocumentViewController.swift
//  MdEditor
//
//  Created by Aksilont on 04.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {
	// MARK: - Private properties
	private let url: URL

	private lazy var textView = makeTextView()
	// MARK: - Initialization
	init(url: URL) {
		self.url = url
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		setupUI()
    }
}

private extension DocumentViewController {
	func setupUI() {
		title = url.lastPathComponent
		view.addSubview(textView)

		getText()
	}

	func makeTextView() -> UITextView {
		let textView = UITextView()
		textView.frame = view.frame
		textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

		// Accessibility: Font
		textView.font = UIFont.preferredFont(forTextStyle: .body)
		textView.adjustsFontForContentSizeCategory = true

		return textView
	}

	func getText() {
		let storage = FileStorage()
		textView.text = storage.loadFileBody(url: url)
	}
}
