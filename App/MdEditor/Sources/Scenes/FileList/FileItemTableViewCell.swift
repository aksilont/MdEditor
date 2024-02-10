//
//  FileItemTableViewCell.swift
//  MdEditor
//
//  Created by Aksilont on 03.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

final class FileItemTableViewCell: UITableViewCell {
	static let cellIdentifier = "FileItemCell"

	// MARK: - Private properties
	private lazy var imageViewIcon = makeImageView()
	private lazy var labelText = makeTextLabel()
	private lazy var labelSecondaryText = makeSecondaryTextLabel()
	private lazy var sView = UIView()

	// MARK: - Initialization
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
		layoutSubviews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle
	override func layoutSubviews() {
		super.layoutSubviews()
		layout()
	}

	// MARK: - Public methods
	func configure(with file: FileListModel.FileViewModel) {
		var imageName = Theme.ImageIcon.unknown
		tintColor = .darkGray
		if file.isDir {
			imageName = Theme.ImageIcon.directory
			tintColor = Theme.tintColor
		} else {
			imageName = Theme.ImageIcon.file
			tintColor = Theme.accentColor
		}
		imageViewIcon.image = UIImage(systemName: imageName)
		labelText.text = file.name
		labelSecondaryText.text = file.description
	}
}

// MARK: - Setup UI
private extension FileItemTableViewCell {
	func makeImageView() -> UIImageView {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		return imageView
	}
	
	func makeTextLabel() -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = Theme.textColor
		label.lineBreakMode = .byTruncatingMiddle
		label.numberOfLines = Sizes.Cell.Text.numberOfLines

		// Accessibility: Font
		label.font = UIFont.preferredFont(forTextStyle: .caption1)
		label.adjustsFontForContentSizeCategory = true
		
		return label
	}

	func makeSecondaryTextLabel() -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = Theme.secondaryTextColor
		label.textAlignment = .right
		label.numberOfLines = Sizes.Cell.SecondaryText.numberOfLines

		// Accessibility: Font
		label.font = UIFont.preferredFont(forTextStyle: .caption2)
		label.adjustsFontForContentSizeCategory = true

		return label
	}

	func setupUI() {
		tintColor = Theme.tintColorCell
		backgroundColor = Theme.backgroundColor

		addSubview(imageViewIcon)
		addSubview(labelText)
		addSubview(labelSecondaryText)
	}

	func layout() {
		let newConstraints = [
			imageViewIcon.centerYAnchor.constraint(equalTo: labelText.centerYAnchor),
			imageViewIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Sizes.Cell.Padding.normal),
			imageViewIcon.heightAnchor.constraint(equalToConstant: Sizes.Cell.Image.height),
			imageViewIcon.widthAnchor.constraint(equalTo: imageViewIcon.heightAnchor),

			labelText.topAnchor.constraint(equalTo: topAnchor, constant: Sizes.Cell.Padding.normal),
			labelText.leadingAnchor.constraint(equalTo: imageViewIcon.trailingAnchor, constant: Sizes.Cell.Padding.normal),
			labelText.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Sizes.Cell.Text.ratioWidth),

			labelSecondaryText.topAnchor.constraint(equalTo: labelText.topAnchor),
			labelSecondaryText.leadingAnchor.constraint(equalTo: labelText.trailingAnchor, constant: Sizes.Cell.Padding.half),
			labelSecondaryText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Sizes.Cell.Padding.normal),
			labelSecondaryText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Sizes.Cell.Padding.normal)
		]
		NSLayoutConstraint.activate(newConstraints)
	}
}
