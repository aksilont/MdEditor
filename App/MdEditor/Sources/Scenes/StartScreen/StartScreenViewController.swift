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

	private var constraints = [NSLayoutConstraint]()

	private var viewModel = StartScreenModel.ViewModel(documents: [])

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
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layout()
	}
}

// MARK: - IStartScreenViewController

extension StartScreenViewController: IStartScreenViewController {
	func render(with viewModel: StartScreenModel.ViewModel) {
		self.viewModel = viewModel
	}
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension StartScreenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		viewModel.documents.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: RecentDocumentCell.reuseIdentifier,
			for: indexPath
		) as? RecentDocumentCell
		
		if let imageData = viewModel.documents[indexPath.item].preview {
			cell?.imageView.image = UIImage(data: imageData.data)
		} else {
			cell?.imageView.image = nil
		}

		cell?.label.text = viewModel.documents[indexPath.item].fileName

		return cell ?? UICollectionViewCell()
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		let width = collectionView.frame.width / 4
		let height = collectionView.frame.height

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
		view.backgroundColor = Theme.backgroundColor

		interactor?.fetchData()
		
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
		layout.minimumLineSpacing = 10

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

	func makeButton(with title: String, and systemImageName: String) -> UIButton {
		let button = UIButton()

		var configuration = UIButton.Configuration.plain()
		configuration.title = title
		configuration.baseForegroundColor = Theme.mainColor
		configuration.image = UIImage(systemName: systemImageName)
//		configuration.imageReservation = Sizes.M.imageWidth
		configuration.imagePadding = Sizes.Padding.half

		button.configuration = configuration

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

	func layout() {
		NSLayoutConstraint.deactivate(constraints)

		let newConstraints = [
			collectionViewDocs.topAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.topAnchor,
				constant: Sizes.Padding.normal
			),
			collectionViewDocs.leadingAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.leadingAnchor,
				constant: Sizes.Padding.normal
			),
			collectionViewDocs.widthAnchor.constraint(equalTo: view.widthAnchor),
			collectionViewDocs.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: Sizes.S.heightMultiplier),

			stackViewButttons.topAnchor.constraint(
				equalTo: collectionViewDocs.bottomAnchor,
				constant: Sizes.Padding.normal
			),
			stackViewButttons.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			stackViewButttons.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		]

		NSLayoutConstraint.activate(newConstraints)

		constraints = newConstraints
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
