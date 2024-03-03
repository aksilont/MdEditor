//
//  AboutScreenViewController.swift
//  MdEditor
//
//  Created by Aleksey Efimov on 09.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

/// Протокол экрана About.
protocol IAboutScreenViewController: AnyObject {
	
	/// Метод отрисовки информации на экране.
	/// - Parameter viewModel: данные для отрисовки на экране.
	func render(viewModel: AboutScreenModel.ViewModel)
}

final class AboutScreenViewController: UIViewController {
	
	// MARK: - Dependencies
	
	var interactor: IAboutScreenInteractor?
	
	// MARK: - Private properties
	
	private lazy var labelFileData: UILabel = makeLabel()
	private lazy var viewContent: UIView = makeView()
	private lazy var scrollView: UIScrollView = makeScrollView()
	
	private var constraints = [NSLayoutConstraint]()
	
	// MARK: - Initialization
	
	init() {
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
}

// MARK: - UI setup

private extension AboutScreenViewController {
	
	func setupUI() {
		title = L10n.About.title
		view.backgroundColor = Theme.backgroundColor
		navigationItem.setHidesBackButton(false, animated: true)
		navigationItem.largeTitleDisplayMode = .never
		navigationController?.navigationBar.tintColor = Theme.mainColor
	}
	
	func makeScrollView() -> UIScrollView {
		let scrollView = UIScrollView(frame: .zero)
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		return scrollView
	}
	
	func makeView() -> UIView {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}
	
	func makeLabel() -> UILabel {
		let label = UILabel()
		label.backgroundColor = Theme.backgroundColor
		label.numberOfLines = 0
		
		label.adjustsFontForContentSizeCategory = true
		
		label.accessibilityIdentifier = AccessibilityIdentifier.AboutScreen.labelFileData
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
}

// MARK: - Layout UI

private extension AboutScreenViewController {
	
	func layout() {
		view.addSubview(scrollView)
		scrollView.addSubview(viewContent)
		viewContent.addSubview(labelFileData)
		
		NSLayoutConstraint.deactivate(constraints)
		
		let safeArea = view.safeAreaLayoutGuide
		
		let newConstraints = [
			scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
			
			viewContent.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
			viewContent.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
			viewContent.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
			viewContent.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
			viewContent.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
			
			labelFileData.topAnchor.constraint(equalTo: viewContent.topAnchor),
			labelFileData.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor, constant: Sizes.Padding.half),
			labelFileData.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor, constant: -Sizes.Padding.half),
			labelFileData.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor)
		]
		
		NSLayoutConstraint.activate(newConstraints)
		
		constraints = newConstraints
	}
}

// MARK: - IMainViewController

extension AboutScreenViewController: IAboutScreenViewController {
	func render(viewModel: AboutScreenModel.ViewModel) {
		self.labelFileData.attributedText = viewModel.fileData
	}
}
