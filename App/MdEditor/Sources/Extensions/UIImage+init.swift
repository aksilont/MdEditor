//
//  UIImage+init Data.swift
//  MdEditor
//
//  Created by Константин Натаров on 01.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

extension UIImage {
	convenience init?(data: Data?) {
		guard let data = data else {
			return nil
		}
		self.init(data: data)
	}
}

extension UIImage {
	convenience init(randomColorWithSize size: CGSize) {
		let renderer = UIGraphicsImageRenderer(size: size)
		let image = renderer.image { context in
			let randomColor = [Colors.green, Colors.orange, Colors.purple].randomElement() ?? .gray
			randomColor.setFill()
			context.fill(CGRect(origin: .zero, size: size))
		}
		self.init(cgImage: image.cgImage!) // swiftlint:disable:this force_unwrapping
	}
}
