//
//  File.swift
//  MdEditor
//
//  Created by Aksilont on 04.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

struct File {
	var url: URL
	var isDir = false
	var nestedFiles: [File] = []
	var creationDate = Date()
	var modificationDate = Date()
	var size: UInt64 = 0

	var name: String { url.lastPathComponent }
	var ext: String { url.pathExtension }
	var parent: String? { url.pathComponents.dropLast().last }
	var path: String { url.relativePath }

	func getFormattedSize(with size: UInt64) -> String {
		var convertedValue = Double(size)
		var multiplyFactor = 0
		let tokens = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
		while convertedValue > 1024 {
			convertedValue /= 1024
			multiplyFactor += 1
		}
		return String(format: multiplyFactor == 0 ? "%.0f %@" : "%4.2f %@", convertedValue, tokens[multiplyFactor])
	}

	func getFormattedSize() -> String {
		return getFormattedSize(with: size)
	}

	func getFormattedAttributes() -> String {
		let formattedSize = getFormattedSize()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd.MM.yy HH:mm"

		return "\(dateFormatter.string(from: modificationDate))\n\(formattedSize)"
	}

	func loadFileBody() -> String {
		var text = ""
		do {
			text = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
		} catch {
			text = "Failed to read text from \(name)"
		}
		return text
	}
}
