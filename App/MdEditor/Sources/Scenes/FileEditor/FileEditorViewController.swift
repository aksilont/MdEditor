//
//  AboutViewController.swift
//  MdEditor
//
//  Created by Aleksey Efimov on 03.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

/// Протокол экрана About.
protocol IFileEditorViewController: AnyObject {
	
	/// Метод отрисовки информации на экране.
	/// - Parameter viewModel: данные для отрисовки на экране.
	func render(viewModel: FileEditorModel.ViewModel)
}

final class FileEditorViewController: UIViewController {
	
	// MARK: - Dependencies
	
	var interactor: IFileEditorInteractor?
	
	// MARK: - Private properties
	
	private var viewModel = FileEditorModel.ViewModel(title: "", fileData: "")
	private var editable: Bool
	
	private lazy var textViewEditor: UITextView = makeTextView()

	private var constraints = [NSLayoutConstraint]()
	
	// MARK: - Initialization
	
	init(editable: Bool) {
		self.editable = editable
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		interactor?.fetchData()
		setupUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		layout()
	}
}

// MARK: - Action

private extension FileEditorViewController {
	@objc
	func updateTextView(notification: Notification) {
		let userInfo = notification.userInfo
		// swiftlint:disable force_cast
		// swiftlint:disable force_unwrapping
		let keyboardScreenEndFrame = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		// swiftlint:enable force_cast
		// swiftlint:enable force_unwrapping
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
		
		if notification.name == UIResponder.keyboardWillHideNotification {
			textViewEditor.contentInset = UIEdgeInsets.zero
		} else {
			textViewEditor.contentInset = UIEdgeInsets(
				top: 0,
				left: 0,
				bottom: keyboardViewEndFrame.height,
				right: 0
			)
			textViewEditor.scrollIndicatorInsets = textViewEditor.contentInset
		}
		textViewEditor.scrollRangeToVisible(textViewEditor.selectedRange)
	}
}

// MARK: - UI setup

private extension FileEditorViewController {
	
	func setupUI() {
		title = viewModel.title == ResourcesBundle.about ? L10n.About.title : viewModel.title
		view.backgroundColor = Theme.backgroundColor
		navigationItem.setHidesBackButton(false, animated: true)
		navigationItem.largeTitleDisplayMode = .never
		navigationController?.navigationBar.tintColor = Theme.mainColor
		
		textViewEditor.text = viewModel.fileData
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(updateTextView),
			name: UIResponder.keyboardDidHideNotification,
			object: nil
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(updateTextView),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)
	}
	
	func makeTextView() -> UITextView {
		let textView = UITextView(frame: .zero, textContainer: nil)
		
		textView.backgroundColor = Theme.backgroundColor
		textView.isScrollEnabled = true
		textView.font = UIFont.preferredFont(forTextStyle: .body)
		textView.adjustsFontForContentSizeCategory = true
		textView.keyboardDismissMode = .onDrag
		textView.isEditable = editable
		textView.translatesAutoresizingMaskIntoConstraints = false
		
		return textView
	}
}

// MARK: - Layout UI

private extension FileEditorViewController {
	
	func layout() {
		view.addSubview(textViewEditor)
		
		NSLayoutConstraint.deactivate(constraints)
		
		let safeArea = view.safeAreaLayoutGuide
		let newConstraints = [
			textViewEditor.topAnchor.constraint(equalTo: safeArea.topAnchor),
			textViewEditor.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Sizes.Padding.half),
			textViewEditor.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Sizes.Padding.half),
			textViewEditor.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: Sizes.Padding.normal)
		]
		
		NSLayoutConstraint.activate(newConstraints)
		
		constraints = newConstraints
	}
}

// MARK: - IMainViewController

extension FileEditorViewController: IFileEditorViewController {
	func render(viewModel: FileEditorModel.ViewModel) {
		self.viewModel = viewModel
		UIView.animate(withDuration: 0.3) { [weak self] in
			self?.textViewEditor.text = viewModel.fileData
			self?.title = viewModel.title == ResourcesBundle.about ? L10n.About.title : viewModel.title
		}
	}
}
