//
//  StartScreenViewController.swift
//  MdEditor
//
//  Created by Константин Натаров on 01.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit
import Combine

protocol IStartScreenViewController: AnyObject {
	func render(with viewModel: StartScreenModel.ViewModel)
}

final class StartScreenViewController: UIViewController, Accessible {
	// MARK: - Dependencies
	var interactor: IStartScreenInteractor?

	// MARK: - Private properties
	private lazy var collectionViewDocs: UICollectionView = makeCollectionView()
	private lazy var buttonNew: UIButton = makeButton(
		with: L10n.StartScreen.newDocumentButtonTitle,
		and: Theme.ImageIcon.file
	)
	private lazy var buttonOpen: UIButton = makeButton(
		with: L10n.StartScreen.openButtonTitle,
		and: Theme.ImageIcon.directory
	)
	private lazy var buttonAbout: UIButton = makeButton(
		with: L10n.StartScreen.aboutButtonTitle,
		and: Theme.ImageIcon.aboutUs
	)
	private lazy var stackViewButttons: UIStackView = makeStackViewButtons()

	private var commonConstraints: [NSLayoutConstraint] = []
	private var narrowConstraints: [NSLayoutConstraint] = []
	private var wideConstraints: [NSLayoutConstraint] = []

	private var viewModel = StartScreenModel.ViewModel.stub

	private var cancellables = Set<AnyCancellable>()

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupConstraints()
		generateAccessibilityIdentifiers()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		let landscape = UIDevice.current.orientation.isLandscape == true
		interactor?.performAction(
			request: .changeCountRecentFiles(landscape: landscape)
		)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		updateConstraints()
	}

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		updateConstraints()
		collectionViewDocs.collectionViewLayout.invalidateLayout()
		
		coordinator.animate { [weak self] _ in
			self?.navigationController?.navigationBar.sizeToFit()
			
			let landscape = UIDevice.current.orientation.isLandscape == true
			self?.interactor?.performAction(
				request: .changeCountRecentFiles(landscape: landscape)
			)
		}
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		
		if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
			cancellables.removeAll()
			collectionViewDocs.reloadData()
		}
	}
}

// MARK: - IStartScreenViewController
extension StartScreenViewController: IStartScreenViewController {
	func render(with viewModel: StartScreenModel.ViewModel) {
		self.viewModel = viewModel
		cancellables.removeAll()
		collectionViewDocs.performBatchUpdates {
			collectionViewDocs.reloadSections(IndexSet(integer: 0))
		}
	}
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension StartScreenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if case let .documents(documents) = viewModel {
			return documents.count
		} else {
			return 1 // swiftlint:disable:this numbers_smell
		}
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: RecentDocumentCell.reuseIdentifier,
			for: indexPath
		) as? RecentDocumentCell else {
			return UICollectionViewCell()
		}
		
		if case let .documents(documents) = viewModel {
			let document = documents[indexPath.item]
			cell.deleteItemPublisher
				.receive(on: RunLoop.main)
				.sink { [weak self] in
					self?.deleteRecentFile(indexPath: indexPath)
				}
				.store(in: &cancellables)
			cell.configure(with: document)
		} else {
			cell.showStub()
		}
		return cell
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		let height = collectionView.frame.height
		let width = height * Sizes.CollectionView.Multiplier.horizontal
		return CGSize(width: width, height: height)
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		switch viewModel {
		case .documents:
			interactor?.performAction(request: .recentFileSelected(indexPath: indexPath))
		case .stub:
			interactor?.performAction(request: .creaeteNewFile)
		}
	}
}

// MARK: - SetupUI
private extension StartScreenViewController {
	func setupUI() {
		title = L10n.StartScreen.title
		navigationItem.setHidesBackButton(true, animated: true)
		navigationItem.backButtonDisplayMode = .minimal
		navigationController?.navigationBar.prefersLargeTitles = true

		view.backgroundColor = Theme.backgroundColor

		buttonNew.configuration?.imagePadding += Sizes.Padding.half

		buttonNew.addTarget(self, action: #selector(buttonNewAction), for: .touchUpInside)
		buttonOpen.addTarget(self, action: #selector(buttonOpenAction), for: .touchUpInside)
		buttonAbout.addTarget(self, action: #selector(buttonAboutAction), for: .touchUpInside)

		collectionViewDocs.dataSource = self
		collectionViewDocs.delegate = self

		view.addSubview(collectionViewDocs)
		view.addSubview(stackViewButttons)
	}

	func makeCollectionView() -> UICollectionView {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = Sizes.CollectionView.Padding.lineSpacing
		layout.sectionInset = Sizes.CollectionView.sectionInset

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		
		collectionView.register(RecentDocumentCell.self, forCellWithReuseIdentifier: RecentDocumentCell.reuseIdentifier)
		collectionView.accessibilityIdentifier = AccessibilityIdentifier.StartScreen.collectionView.description

		collectionView.showsHorizontalScrollIndicator = false
		collectionView.backgroundColor = .clear

		collectionView.translatesAutoresizingMaskIntoConstraints = false

		return collectionView
	}

	func makeButton(with title: String, and image: UIImage?) -> UIButton {
		let button = UIButton()

		var configuration = UIButton.Configuration.plain()
		configuration.title = title
		configuration.baseForegroundColor = Theme.mainColor
		configuration.image = image
		configuration.imagePadding = Sizes.Padding.half
		
		configuration.contentInsets.leading = 0
		
		button.configuration = configuration

		// Accessibility: Font
		button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
		button.titleLabel?.adjustsFontForContentSizeCategory = true

		button.translatesAutoresizingMaskIntoConstraints = false

		return button
	}

	func makeStackViewButtons() -> UIStackView {
		let stackView = UIStackView(arrangedSubviews: [buttonNew, buttonOpen, buttonAbout])
		stackView.axis = .vertical
		stackView.spacing = Sizes.Padding.normal
		stackView.alignment = .leading
		stackView.distribution = .fill

		stackView.translatesAutoresizingMaskIntoConstraints = false

		return stackView
	}
}

// MARK: - Layout
private extension StartScreenViewController {
	func setupConstraints() {
		commonConstraints = [
			collectionViewDocs.topAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.topAnchor,
				constant: Sizes.Padding.normal
			),
			collectionViewDocs.leadingAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.leadingAnchor
			),
			collectionViewDocs.trailingAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.trailingAnchor
			),

			stackViewButttons.topAnchor.constraint(
				equalTo: collectionViewDocs.bottomAnchor,
				constant: Sizes.Padding.normal
			),
			stackViewButttons.leadingAnchor.constraint(
				equalTo: collectionViewDocs.leadingAnchor,
				constant: Sizes.Padding.normal
			)
		]

		narrowConstraints = [
			collectionViewDocs.heightAnchor.constraint(
				equalTo: view.heightAnchor,
				multiplier: Sizes.CollectionView.Multiplier.vertical
			)
		]

		wideConstraints = [
			collectionViewDocs.heightAnchor.constraint(
				equalTo: view.widthAnchor,
				multiplier: Sizes.CollectionView.Multiplier.vertical
			)
		]

		NSLayoutConstraint.activate(commonConstraints)
		if UIDevice.current.orientation.isLandscape {
			NSLayoutConstraint.activate(wideConstraints)
		} else {
			NSLayoutConstraint.activate(narrowConstraints)
		}
	}

	func updateConstraints() {
		if UIDevice.current.orientation.isLandscape {
			NSLayoutConstraint.deactivate(narrowConstraints)
			NSLayoutConstraint.activate(wideConstraints)
			if stackViewButttons.frame.maxY > view.frame.maxY {
				stackViewButttons.axis = .horizontal
			}
		} else {
			NSLayoutConstraint.deactivate(wideConstraints)
			NSLayoutConstraint.activate(narrowConstraints)
			stackViewButttons.axis = .vertical
		}
	}
}

// MARK: - Actions
private extension StartScreenViewController {
	@objc
	func buttonNewAction(_ sender: UIButton) {
		interactor?.performAction(request: .creaeteNewFile)
	}

	@objc
	func buttonOpenAction(_ sender: UIButton) {
		interactor?.performAction(request: .openFileList)
	}

	@objc
	func buttonAboutAction(_ sender: UIButton) {
		interactor?.performAction(request: .showAbout)
	}

	func deleteRecentFile(indexPath: IndexPath) {
		interactor?.performAction(request: .deleteRecentFile(indexPath: indexPath))
	}
}
