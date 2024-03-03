//
//  ScanFileManager.swift
//  MdEditor
//
//  Created by Aksilont on 22.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

protocol IScanFileManager {
	func scanFiles(with urls: [URL]) async throws -> [FileSystemEntity]
}

actor ScanFileManager: IScanFileManager {
	// MARK: - Private properties
	private let fileManager = FileManager.default
	private let storage: IStorageService

	init(storage: IStorageService) {
		self.storage = storage
	}

	func scanFiles(with urls: [URL]) async throws -> [FileSystemEntity] {
		var files: [FileSystemEntity?] = []
		for item in urls {
			if item.hasDirectoryPath {
				let contents = try fileManager.contentsOfDirectory(
					at: item,
					includingPropertiesForKeys: nil,
					options: .skipsHiddenFiles
				)
				for nestedItem in contents {
					let nestedFiles = try await scanFiles(with: [nestedItem])
					files.append(contentsOf: nestedFiles)
				}
			} else {
				let file = try storage.getEntity(from: item, with: [])
				files.append(file)
			}
		}
		return files.compactMap { $0 }
	}
}
