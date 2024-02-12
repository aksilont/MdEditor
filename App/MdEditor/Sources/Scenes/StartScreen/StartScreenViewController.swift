//
//  StartScreenViewController.swift
//  MdEditor
//
//  Created by Константин Натаров on 01.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

protocol IStartScreenViewController: AnyObject {
	func render(with viewModel: StartScreenModel.ViewModel)
}

final class StartScreenViewController: UIViewController {

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

	private var viewModel = StartScreenModel.ViewModel(documents: [])

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupConstraints()
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
		}
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		collectionViewDocs.reloadData()
	}
}

// MARK: - IStartScreenViewController

extension StartScreenViewController: IStartScreenViewController {
	func render(with viewModel: StartScreenModel.ViewModel) {
		self.viewModel = viewModel
		collectionViewDocs.reloadData()
	}
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension StartScreenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		viewModel.documents.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		guard let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: RecentDocumentCell.reuseIdentifier,
			for: indexPath
		) as? RecentDocumentCell else {
			return UICollectionViewCell()
		}
		let document = viewModel.documents[indexPath.item]
		cell.configure(with: document)

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
}

// MARK: - SetupUI

private extension StartScreenViewController {
	func setupUI() {
		title = L10n.StartScreen.title
		navigationItem.setHidesBackButton(true, animated: true)
		navigationItem.backButtonDisplayMode = .minimal
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.backButtonDisplayMode = .minimal
		view.backgroundColor = Theme.backgroundColor

		interactor?.fetchData()

		buttonNew.configuration?.imagePadding += Sizes.Padding.half

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

		let itemWidth = view.frame.width
		let itemHeight = view.frame.height

		layout.itemSize = CGSize(width: itemWidth, height: itemHeight)

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.register(RecentDocumentCell.self, forCellWithReuseIdentifier: RecentDocumentCell.reuseIdentifier)
		collectionView.isPagingEnabled = true
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
				equalTo: view.safeAreaLayoutGuide.leadingAnchor,
				constant: Sizes.Padding.normal
			),
			collectionViewDocs.trailingAnchor.constraint(equalTo: view.trailingAnchor),

			stackViewButttons.topAnchor.constraint(
				equalTo: collectionViewDocs.bottomAnchor,
				constant: Sizes.Padding.normal
			),
			stackViewButttons.leadingAnchor.constraint(equalTo: collectionViewDocs.leadingAnchor)
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
	func buttonOpenAction(_ sender: UIButton) {
		interactor?.openFileList()
	}

	@objc
	func buttonAboutAction(_ sender: UIButton) {
		interactor?.openAbout()
	}
}
