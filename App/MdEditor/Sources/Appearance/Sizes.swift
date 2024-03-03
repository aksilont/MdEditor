//
//  Sizes.swift
//  MdEditor
//
//  Created by Kirill Leonov on 14.11.2023.
//

import UIKit

// swiftlint:disable type_name
enum Sizes {

	static let cornerRadius: CGFloat = 6
	static let borderWidth: CGFloat = 1
	static let topInset: CGFloat = 180.0
	
	enum Padding {
		static let minimum: CGFloat = 4
		static let half: CGFloat = 8
		static let semiNormal: CGFloat = 14
		static let normal: CGFloat = 16
		static let double: CGFloat = 32
	}

	enum L {
		static let width: CGFloat = 200
		static let height: CGFloat = 50
		static let widthMultiplier: CGFloat = 0.9
		static let imageWidth: CGFloat = 50
	}

	enum M {
		static let width: CGFloat = 100
		static let height: CGFloat = 40
		static let heightMultiplier: CGFloat = 0.8
		static let imageWidth: CGFloat = 40
	}

	enum S {
		static let width: CGFloat = 80
		static let height: CGFloat = 30
		static let heightMultiplier: CGFloat = 0.25
		static let imageWidth: CGFloat = 30
	}

	enum TableView {
		static let countRow = 10
		enum Cell {
			enum Padding {
				static let half: CGFloat = 4
				static let normal: CGFloat = 8
				static let double: CGFloat = 16
			}
			enum Image {
				static let width: CGFloat = 40
				static let height: CGFloat = 40
			}
			enum Text {
				static let ratioWidth: CGFloat = 0.5
				static let numberOfLines = 3
			}
			enum SecondaryText {
				static let numberOfLines = 3
			}
		}
	}

	enum CollectionView {
		enum Padding {
			static let lineSpacing: CGFloat = 20
		}

		static let sectionInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)

		enum Multiplier {
			static let vertical: CGFloat = 1 / 5
			static let horizontal: CGFloat = 2 / 3

			static let horizontalItems: CGFloat = 10
			static let verticalItems: CGFloat = 5
		}
	}

	enum Preview {
		static let fontSize: CGFloat = 5
		enum Padding {
			static let x: CGFloat = 10
			static let y: CGFloat = 10
		}
	}
}
// swiftlint:enable type_name
