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

	let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.layer.cornerRadius = Sizes.cornerRadius
		return imageView
	}()

	let label: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = Theme.mainColor
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupViews()
	}

	private func setupViews() {
		addSubview(imageView)
		addSubview(label)

		imageView.translatesAutoresizingMaskIntoConstraints = false
		label.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: topAnchor),
			imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
			imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Sizes.M.heightMultiplier),

			label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Sizes.Padding.half),
			label.leadingAnchor.constraint(equalTo: leadingAnchor),
			label.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}
}
