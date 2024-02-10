//
//  FileStorage.swift
//  MdEditor
//
//  Created by Aksilont on 04.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

protocol IFileStorage {
	func scan(url: URL) throws -> [File]
	func getFilesFrom(_ items: [URL]) throws -> [File]
	func loadFileBody(url: URL) -> String
	func getAllDocs() -> [Document]
}

final class FileStorage: IFileStorage {
	// MARK: - Private properties
	private let fileManager = FileManager.default

	// MARK: - Public methods
	func scan(url: URL) throws -> [File] {
		guard url.hasDirectoryPath else { return [] }

		var files: [File] = []
		let contents = try fileManager.contentsOfDirectory(
			at: url,
			includingPropertiesForKeys: nil,
			options: .skipsHiddenFiles
		)

		for item in contents {
			let attributes = try fileManager.attributesOfItem(atPath: item.relativePath)
			let creationDate = (attributes[FileAttributeKey.creationDate] as? Date) ?? Date()
			let modificationDate = (attributes[FileAttributeKey.modificationDate] as? Date) ?? Date()

			if item.hasDirectoryPath {
				let nestedFiles = try scan(url: item)
				let size = nestedFiles.reduce(into: 0) { partialResult, nextFile in
					partialResult += nextFile.size
				}
				let directory = File(
					url: item,
					isDir: true,
					nestedFiles: nestedFiles,
					creationDate: creationDate,
					modificationDate: modificationDate,
					size: size
				)
				files.append(directory)
			} else {
				let size = (attributes[FileAttributeKey.size] as? UInt64) ?? 0
				let file = File(
					url: item,
					creationDate: creationDate,
					modificationDate: modificationDate,
					size: size
				)
				files.append(file)
			}
		}

		return files
	}

	func getFilesFrom(_ items: [URL]) throws -> [File] {
		var files: [File] = []
		for item in items {
			guard item.hasDirectoryPath else { continue }

			let attributes = try fileManager.attributesOfItem(atPath: item.relativePath)
			let creationDate = (attributes[FileAttributeKey.creationDate] as? Date) ?? Date()
			let modificationDate = (attributes[FileAttributeKey.modificationDate] as? Date) ?? Date()

			let nestedFiles = try scan(url: item)
			let size = nestedFiles.reduce(into: 0) { partialResult, nextFile in
				partialResult += nextFile.size
			}
			let directory = File(
				url: item,
				isDir: true,
				nestedFiles: nestedFiles,
				creationDate: creationDate,
				modificationDate: modificationDate,
				size: size
			)
			files.append(directory)
		}
		return files
	}

	func loadFileBody(url: URL) -> String {
		var text = ""
		do {
			text = try String(contentsOf: url, encoding: String.Encoding.utf8)
		} catch {
			text = "Failed to read text from \(url.lastPathComponent)"
		}

		return text
	}
	/// Возвращает массив всех документов в приложении
	func getAllDocs() -> [Document] {
		var docs: [Document] = []
		let bundleUrl = Bundle.main.bundleURL
		let docsURL = bundleUrl.appendingPathComponent("Documents.bundle")

		func processDirectory(at directoryURL: URL) {
			do {
				let contents = try fileManager.contentsOfDirectory(
					at: directoryURL,
					includingPropertiesForKeys: nil,
					options: .skipsHiddenFiles
				)

				for item in contents {
					if item.hasDirectoryPath {
						processDirectory(at: item)
					} else if item.pathExtension == "md" {
						let fileName = item.lastPathComponent
						let preview = UIImage(randomColorWithSize: CGSize(width: 150, height: 250))
						docs.append(Document(fileName: fileName, preview: preview))
					}
				}
			} catch let error as NSError {
				fatalError(error.localizedDescription)
			}
		}

		processDirectory(at: docsURL)

		return docs
	}
}

struct Document {
	let fileName: String
	let preview: UIImage?
}
