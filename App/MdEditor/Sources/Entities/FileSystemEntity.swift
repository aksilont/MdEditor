//
//  FileSystemEntity.swift
//  MdEditor
//
//  Created by Aksilont on 07.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

struct FileSystemEntity {
	var path: String = ""
	var isDir = false
	var creationDate = Date()
	var modificationDate = Date()
	var size: UInt64 = .zero

	var url: URL { URL(fileURLWithPath: path, relativeTo: ResourcesBundle.bundle) }
	var name: String { url.lastPathComponent.replacingOccurrences(of: ".\(ext)", with: "") }
	var fullName: String { url.lastPathComponent }
	var ext: String { url.pathExtension }
	var parent: String? { url.pathComponents.dropLast().last }

	func loadFileBody() -> String {
		var text = ""
		do {
			text = try String(contentsOf: url, encoding: String.Encoding.utf8)
		} catch {
			text = "Failed to read text from \(fullName)"
		}
		return text
	}
}

extension FileSystemEntity: Comparable {
	static func < (lhs: FileSystemEntity, rhs: FileSystemEntity) -> Bool {
		lhs.modificationDate < rhs.modificationDate
	}
}

extension FileSystemEntity: Codable {
}
