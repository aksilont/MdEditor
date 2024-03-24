//
//  AboutViewController.swift
//  MdEditor
//
//  Created by Aleksey Efimov on 03.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit
import Combine

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
	private lazy var menuBarButton = makeBarButton(
		image: Theme.ImageIcon.menuButton,
		action: #selector(menuButtonAction),
		accessibilityIdentifier: AccessibilityIdentifier.FileList.menuBarButton.description
	)
	private var viewModel = FileEditorModel.ViewModel(title: "", fileData: NSMutableAttributedString())
	private var editable: Bool
	
	private lazy var textViewEditor: UITextView = makeTextView()
	private lazy var popover = PopoverViewController()

	private var constraints = [NSLayoutConstraint]()

	private var cancellable: AnyCancellable?

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
		setupUI()
		interactor?.fetchData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		layout()
	}

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		popover.dismiss(animated: true)
	}
}

// MARK: - Actions
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

	@objc
	func menuButtonAction(_ sender: UIBarItem) {
		popover.modalPresentationStyle = .popover
		cancellable = popover.performActionPublisher
			.receive(on: RunLoop.main)
			.compactMap { $0 }
			.sink { [weak interactor, weak popover] action in
				if case .exportToPDF = action {
					popover?.dismiss(animated: true)
					interactor?.performAction(request: .exportToPDF)
				}
			}
		guard let presentingVC = popover.popoverPresentationController else { return }
		presentingVC.delegate = self
		presentingVC.sourceView = view
		presentingVC.permittedArrowDirections = []
		presentingVC.sourceRect = CGRect(
			x: view.bounds.width - view.safeAreaInsets.right,
			y: view.safeAreaInsets.top + Sizes.Padding.double,
			width: 0,
			height: 0
		)

		present(popover, animated: true)
	}
}

// MARK: - UI setup
private extension FileEditorViewController {
	func setupUI() {
		view.backgroundColor = Theme.backgroundColor

		navigationController?.navigationBar.tintColor = Theme.mainColor

		navigationItem.setHidesBackButton(false, animated: true)
		navigationItem.backButtonDisplayMode = .minimal
		navigationItem.largeTitleDisplayMode = .never
		navigationItem.rightBarButtonItem = menuBarButton

		textViewEditor.attributedText = viewModel.fileData
		
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

	func makeBarButton(
		image: UIImage?,
		action: Selector?,
		accessibilityIdentifier: String = ""
	) -> UIBarButtonItem {
		let barButtonItem = UIBarButtonItem(
			image: image,
			style: .plain,
			target: self,
			action: action
		)
		if !accessibilityIdentifier.isEmpty {
			barButtonItem.accessibilityIdentifier = accessibilityIdentifier
		}

		return barButtonItem
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
			textViewEditor.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Sizes.Padding.normal)
		]
		
		NSLayoutConstraint.activate(newConstraints)
		
		constraints = newConstraints
	}
}

// MARK: - IFileEditorViewController
extension FileEditorViewController: IFileEditorViewController {
	func render(viewModel: FileEditorModel.ViewModel) {
		self.viewModel = viewModel
		title = viewModel.title
		textViewEditor.attributedText = viewModel.fileData
	}
}

// MARK: - UIPopoverPresentationControllerDelegate
extension FileEditorViewController: UIPopoverPresentationControllerDelegate {
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		.none
	}
}
