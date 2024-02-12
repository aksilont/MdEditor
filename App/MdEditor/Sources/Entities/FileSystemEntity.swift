//
//  FileSystemEntity.swift
//  MdEditor
//
//  Created by Aksilont on 07.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

struct FileSystemEntity {
	var url: URL
	var isDir = false
	var creationDate = Date()
	var modificationDate = Date()
	var size: UInt64 = .zero

	var name: String { url.lastPathComponent.replacingOccurrences(of: ".\(ext)", with: "") }
	var fullName: String { url.lastPathComponent }
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
		dateFormatter.dateFormat = L10n.FileList.dateFormat

		if isDir {
			return "\(dateFormatter.string(from: modificationDate)) | <dir>"
		} else {
			return "\"\(ext)\" – \(dateFormatter.string(from: modificationDate)) | \(formattedSize)"
		}
	}

	func loadFileBody() -> String {
		var text = ""
		do {
			text = try String(contentsOf: url, encoding: String.Encoding.utf8)
		} catch {
			text = "Failed to read text from \(url.lastPathComponent)"
		}
		return text
	}
}

extension FileSystemEntity: Comparable {
	static func < (lhs: FileSystemEntity, rhs: FileSystemEntity) -> Bool {
		lhs.modificationDate < rhs.modificationDate
	}
}
