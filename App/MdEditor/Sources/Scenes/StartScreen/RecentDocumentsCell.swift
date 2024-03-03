//
//  RecentDocumentsCell.swift
//  MdEditor
//
//  Created by Константин Натаров on 01.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit
import Combine

final class RecentDocumentCell: UICollectionViewCell {
	static let reuseIdentifier = String(describing: RecentDocumentCell.self)

	// MARK: - Private Properties
	private lazy var imageView = makeImageView()
	private lazy var label = makeLabel()
	private lazy var imageViewDeleteItem = makeImageViewDeleteItem()

	var deleteItemPublisher = PassthroughSubject<Void, Never>()

	// MARK: - Initialization
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	// MARK: - Public Methods
	func configure(with document: StartScreenModel.Document) {
		imageView.image = nil

		label.text = document.fileName
		layoutSubviews()
		imageView.image = imageView.snapshot(with: document.content)

		imageViewDeleteItem.isHidden = false
		imageViewDeleteItem.isUserInteractionEnabled = true
	}

	func showStub() {
		imageView.image = nil
		label.text = nil

		let insets = UIEdgeInsets(
			top: -Sizes.Padding.normal,
			left: -Sizes.Padding.normal,
			bottom: -Sizes.Padding.normal,
			right: -Sizes.Padding.normal
		)
		imageView.image = Theme.ImageIcon.newFile?.withAlignmentRectInsets(insets)
		imageView.tintColor = Theme.stubColor

		imageViewDeleteItem.isHidden = true
		imageViewDeleteItem.isUserInteractionEnabled = false
	}
}

// MARK: - Setup View
private extension RecentDocumentCell {
	func makeImageView() -> UIImageView {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		return imageView
	}

	func makeLabel() -> UILabel {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = Theme.mainColor
		label.setContentCompressionResistancePriority(.required, for: .vertical)
		label.setContentHuggingPriority(.required, for: .vertical)
		label.lineBreakStrategy = .hangulWordPriority
		label.lineBreakMode = .byTruncatingMiddle

		// Accessibility: Font
		label.font = UIFont.preferredFont(forTextStyle: .caption1)
		label.adjustsFontForContentSizeCategory = true

		return label
	}

	func makeImageViewDeleteItem() -> UIImageView {
		let imageView = UIImageView(image: Theme.ImageIcon.deleteFile)
		imageView.tintColor = Theme.tintColor
		let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(deleteItemAction))
		imageView.addGestureRecognizer(tapGestureRecogniser)
		imageView.isUserInteractionEnabled = true
		return imageView
	}

	func setupView() {
		addSubview(imageView)
		addSubview(label)
		addSubview(imageViewDeleteItem)

		imageView.addBorder(radius: Sizes.cornerRadius)

		imageView.translatesAutoresizingMaskIntoConstraints = false
		label.translatesAutoresizingMaskIntoConstraints = false
		imageViewDeleteItem.translatesAutoresizingMaskIntoConstraints = false

		setupConstraints()
	}

	func setupConstraints() {
		NSLayoutConstraint.activate([
			imageViewDeleteItem.topAnchor.constraint(equalTo: topAnchor),
			imageViewDeleteItem.trailingAnchor.constraint(equalTo: trailingAnchor),
			imageViewDeleteItem.widthAnchor.constraint(equalTo: imageViewDeleteItem.heightAnchor),

			imageView.topAnchor.constraint(equalTo: imageViewDeleteItem.centerYAnchor),
			imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: imageViewDeleteItem.centerXAnchor),

			label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Sizes.Padding.minimum),
			label.leadingAnchor.constraint(equalTo: leadingAnchor),
			label.trailingAnchor.constraint(equalTo: imageViewDeleteItem.centerXAnchor),
			label.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}

// MARK: - Actions
private extension RecentDocumentCell {
	@objc
	func deleteItemAction() {
		deleteItemPublisher.send()
	}
}
