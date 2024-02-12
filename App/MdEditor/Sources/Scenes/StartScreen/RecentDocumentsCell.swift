//
//  RecentDocumentsCell.swift
//  MdEditor
//
//  Created by Константин Натаров on 01.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

final class RecentDocumentCell: UICollectionViewCell {
	static let reuseIdentifier = "RecentDocCell"

	// MARK: - Private Properties
	private lazy var imageView = makeImageView()
	private lazy var label = makeLabel()

	// MARK: - Lyfecycle
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	// MARK: - Public Methods
	func configure(with document: StartScreenModel.Document) {
		label.text = document.fileName
		layoutSubviews()
		imageView.image = imageView.snapshot(with: document.content)
	}
}

// MARK: - Setup View
private extension RecentDocumentCell {
	func makeImageView() -> UIImageView {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true
		imageView.layer.cornerRadius = Sizes.cornerRadius
		imageView.layer.borderColor = UIColor.systemGray.cgColor
		imageView.layer.borderWidth = 1
		return imageView
	}

	func makeLabel() -> UILabel {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = Theme.mainColor
		label.setContentCompressionResistancePriority(.required, for: .vertical)

		// Accessibility: Font
		label.font = UIFont.preferredFont(forTextStyle: .body)
		label.adjustsFontForContentSizeCategory = true

		return label
	}
	
	func setupView() {
		addSubview(imageView)
		addSubview(label)

		imageView.translatesAutoresizingMaskIntoConstraints = false
		label.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: topAnchor),
			imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
			imageView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),

			label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Sizes.Padding.half),
			label.leadingAnchor.constraint(equalTo: leadingAnchor),
			label.trailingAnchor.constraint(equalTo: trailingAnchor),
			label.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}
