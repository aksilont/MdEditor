//
//  FileStorageService.swift
//  MdEditor
//
//  Created by Aksilont on 06.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

enum StorageError: Error {
	case errorURL
	case errorFetching
	case errorCreating
	case errorDeleting
}

protocol IStorageService {
	/// Получить файлы/папки
	/// - Parameter url: источники для получения файла
	/// - Returns: `Result<[FileSystemEntity], StorageError>`
	func fetchData(of url: URL?) async -> Result<[FileSystemEntity], StorageError>

	/// Получить сущность файла
	/// - Parameters:
	///   - url: `URL` файла
	///   - ext: массив расширений для отбора
	/// - Returns: `Optional(FileSystemEntity)`
	func getEntity(from url: URL, with ext: [String]) throws -> FileSystemEntity?

	/// Загрузить данные из файла
	/// - Parameter url: адрес файла
	/// - Returns: текстовое представление файла
	func loadFile(from url: URL) -> String
}

final class FileStorageService: IStorageService {
	// MARK: - Private properties
	private let fileManager: FileManager
	private let defaultURL: [URL]
	private let ext: [String]

	init(
		fileManager: FileManager = FileManager.default,
		defaultURL: [URL] = [],
		ext: [String] = []
	) {
		self.fileManager = fileManager
		self.defaultURL = defaultURL
		self.ext = ext
	}

	// MARK: - Public methods
	func fetchData(of url: URL?) async -> Result<[FileSystemEntity], StorageError> {
		if let url {
			return fetchNestedFiles(of: url)
		} else {
			var result: [FileSystemEntity] = []
			for url in defaultURL {
				guard let entity = try? getEntity(from: url, with: ext) else { continue }
				result.append(entity)
			}
			return .success(result)
		}
	}

	func getEntity(from url: URL, with ext: [String] = []) throws -> FileSystemEntity? {
		// Если это файл и указано расширение - выполнить проверку на соответствие указанному расширению
		if !ext.isEmpty, !url.hasDirectoryPath, !ext.contains(url.pathExtension) { return nil }

		let attributes = try fileManager.attributesOfItem(atPath: url.relativePath)
		let creationDate = (attributes[FileAttributeKey.creationDate] as? Date) ?? Date()
		let modificationDate = (attributes[FileAttributeKey.modificationDate] as? Date) ?? Date()
		let size = (attributes[FileAttributeKey.size] as? UInt64) ?? .zero

		let relativePath = url.relativePath
		let bundlePath = ResourcesBundle.bundlePath + "/"
		let path = relativePath.replacingOccurrences(of: bundlePath, with: "")

		return FileSystemEntity(
			path: path,
			isDir: url.hasDirectoryPath,
			creationDate: creationDate,
			modificationDate: modificationDate,
			size: size
		)
	}

	func loadFile(from url: URL) -> String {
		guard let file = try? getEntity(from: url) else { return "" }
		return file.loadFileBody()
	}
}

// MARK: - Private methods
private extension FileStorageService {
	func fetchNestedFiles(of url: URL) -> Result<[FileSystemEntity], StorageError> {
		var files: [FileSystemEntity?] = []
		do {
			var contents: [URL] = []
			if url.hasDirectoryPath {
				contents = try fileManager.contentsOfDirectory(
					at: url,
					includingPropertiesForKeys: nil,
					options: .skipsHiddenFiles
				)
			} else {
				contents = [url]
			}
			for item in contents {
				let entity = try getEntity(from: item, with: ext)
				files.append(entity)
			}
		} catch {
			return .failure(.errorURL)
		}
		return .success(files.compactMap { $0 })
	}
}
