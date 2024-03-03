//
//  Sequence+Joined.swift
//  MdEditor
//
//  Created by Aleksey Efimov on 26.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

public extension Sequence where Iterator.Element == NSMutableAttributedString {
	func joined(separator: String = "") -> NSMutableAttributedString {
		reduce(into: NSMutableAttributedString()) {
			let separator = separator.attributed
			$0.append(separator)
			$0.append($1)
		}
	}
}
