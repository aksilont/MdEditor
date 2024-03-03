//
//  UIView+Snapshot.swift
//  MdEditor
//
//  Created by Aksilont on 11.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

extension UIView {
	func snapshot(with text: String) -> UIImage {
		return UIGraphicsImageRenderer(bounds: bounds).image { context in
			Theme.previewColor.setFill()
			context.fill(bounds)

			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.alignment = .left

			let attributes = [
				NSAttributedString.Key.font: UIFont.systemFont(ofSize: Sizes.Preview.fontSize),
				NSAttributedString.Key.paragraphStyle: paragraphStyle,
				NSAttributedString.Key.foregroundColor: Theme.textColor
			]

			let rect = CGRect(
				x: Sizes.Preview.Padding.x,
				y: Sizes.Preview.Padding.y,
				width: bounds.width - (Sizes.Preview.Padding.x * 2),
				height: bounds.height - (Sizes.Preview.Padding.y * 2)
			)

			text.draw(
				with: rect,
				options: .usesLineFragmentOrigin,
				attributes: attributes,
				context: nil
			)
		}
	}
}
