//
//  String+RegularExpression.swift
//
//
//  Created by Aksilont on 16.02.2024.
//

import Foundation

public extension String {
	func substring(with range: NSRange) -> Self {
		(self as NSString).substring(with: range)
	}

	func firstMatch(pattern: Self) -> NSTextCheckingResult? {
		do {
			let regex = try NSRegularExpression(pattern: pattern)
			let range = NSRange(startIndex..., in: self)
			return regex.firstMatch(in: self, range: range)
		} catch let error {
			print("invalid regex: \(error.localizedDescription)")
			return nil
		}
	}

	func groups(for regexPattern: String) -> [String] {
		var result:[String] = []
		if let match = firstMatch(pattern: regexPattern) {
			for group in 0..<match.numberOfRanges {
				let range = match.range(at: group)
				let text = substring(with: range)
				result.append(text)
			}
		}
		return result
	}
}
