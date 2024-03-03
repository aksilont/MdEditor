//
//  UIView+AddBorder.swift
//  MdEditor
//
//  Created by Aksilont on 26.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

extension UIView {
	func addBorder(
		radius: CGFloat,
		color: UIColor = UIColor.systemGray,
		width: CGFloat = 1
	) {
		guard let rootView = superview,
			  let currentIndexView = rootView.subviews.firstIndex(of: self)
		else { return }

		let borderView = UIView()
		borderView.translatesAutoresizingMaskIntoConstraints = false
		borderView.backgroundColor = .clear
		
		borderView.layer.cornerRadius = layer.cornerRadius
		borderView.layer.cornerCurve = layer.cornerCurve
		borderView.layer.maskedCorners = layer.maskedCorners

		borderView.clipsToBounds = true
		borderView.layer.cornerRadius = radius
		borderView.layer.borderColor = color.cgColor
		borderView.layer.borderWidth = width

		clipsToBounds = true
		layer.cornerRadius = Sizes.cornerRadius

		rootView.insertSubview(borderView, at: currentIndexView + 1)

		NSLayoutConstraint.activate([
			borderView.topAnchor.constraint(equalTo: topAnchor),
			borderView.leftAnchor.constraint(equalTo: leftAnchor),
			borderView.rightAnchor.constraint(equalTo: rightAnchor),
			borderView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}
