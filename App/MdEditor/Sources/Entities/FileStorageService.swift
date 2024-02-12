//
//  FileStorageService.swift
//  MdEditor
//
//  Created by Aksilont on 06.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

enum ResourcesBundle {
	static let assets: String = "Assets"
	static let about: String = "about.md"
	static let extMD: String = "md"

	static var defaultsUrls: [URL] {
		var urls: [URL] = []
		let bundleUrl = Bundle.main.resourceURL
		if let docsURL = bundleUrl?.appendingPathComponent(assets) {
			urls.append(docsURL)
		}
		if let homeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			urls.append(homeURL)
		}
		return urls
	}
}

enum StorageError: Error {
	case errorURL
	case errorFetching
	case errorCreating
	case errorDeleting
}

protocol IStorageService {
	/// Получить файлы/папки
	/// - Parameter urls: источники для получения
	/// - Returns: `Result<[FileSystemEntity], StorageError>`
	func fetchData(urls: [URL]) async -> Result<[FileSystemEntity], StorageError>
	/// Показать последние файлы
	/// - Parameters:
	///   - count: кол-во последних файлов
	///   - urls: массив источников
	/// - Returns: `Result<[FileSystemEntity], StorageError>`
	func fetchRecent(count: Int?, with urls: [URL]) async -> Result<[FileSystemEntity], StorageError>
	/// Загрузить данные из файла
	/// - Parameter url: адрес файла
	/// - Returns: текстовое представление файла
	func loadFileBody(url: URL) async -> String
}

actor FileStorageService: IStorageService {
	// MARK: - Private properties
	private let fileManager = FileManager.default

	// MARK: - Public methods
	func fetchData(urls: [URL]) -> Result<[FileSystemEntity], StorageError> {
		do {
			/// В случае передачи 1 URL - возвращает данные о вложенных файлах/папка по этому адресу
			/// Иначе возвращает `[FileSystemEntity]` по заданным URL
			if urls.count == 1 {
				guard let url = urls.first else { return .failure(.errorURL) }
				let result = try fetch(with: url)
				return .success(result)
			} else {
				let result = try fetchRoot(urls)
				return .success(result)
			}
		} catch {
			return .failure(.errorFetching)
		}
	}

	func fetchRecent(count: Int? = nil, with urls: [URL]) -> Result<[FileSystemEntity], StorageError> {
		do {
			/// Ищет указанное кол-во файлов по всем источникам
			/// В реальной ситуации надо использовать UserDefaults для сохранения и чтения URL открытых файлов
			let result = try scanFiles(with: urls).sorted(by: >)
			guard let count else { return.success(result) }
			let filteredResult = Array(result.prefix(count))
			return.success(filteredResult)
		} catch {
			return .failure(.errorFetching)
		}
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
}

// MARK: - Private methods
private extension FileStorageService {
	func scanFiles(with urls: [URL]) throws -> [FileSystemEntity] {
		var files: [FileSystemEntity?] = []
		for item in urls {
			if item.hasDirectoryPath {
				let contents = try fileManager.contentsOfDirectory(
					at: item,
					includingPropertiesForKeys: nil,
					options: .skipsHiddenFiles
				)
				for nestedItem in contents {
					let nestedFiles = try scanFiles(with: [nestedItem])
					files.append(contentsOf: nestedFiles)
				}
			} else {
				let file = try getEntity(from: item)
				files.append(file)
			}
		}
		return files.compactMap { $0 }
	}

	func getEntity(from url: URL, with ext: [String] = [ResourcesBundle.extMD]) throws -> FileSystemEntity? {
		// Если это файл и указано расширение - выполнить проверку на соответствие указанному расширению
		if !ext.isEmpty, !url.hasDirectoryPath, !ext.contains(url.pathExtension) { return nil }

		let attributes = try fileManager.attributesOfItem(atPath: url.relativePath)
		let creationDate = (attributes[FileAttributeKey.creationDate] as? Date) ?? Date()
		let modificationDate = (attributes[FileAttributeKey.modificationDate] as? Date) ?? Date()
		let size = (attributes[FileAttributeKey.size] as? UInt64) ?? .zero

		return FileSystemEntity(
			url: url,
			isDir: url.hasDirectoryPath,
			creationDate: creationDate,
			modificationDate: modificationDate,
			size: size
		)
	}

	func fetchRoot(_ urls: [URL]) throws -> [FileSystemEntity] {
		var files: [FileSystemEntity?] = []
		for item in urls {
			let entity = try getEntity(from: item)
			files.append(entity)
		}
		return files.compactMap { $0 }
	}

	func fetch(with url: URL) throws -> [FileSystemEntity] {
		var files: [FileSystemEntity?] = []
		if url.hasDirectoryPath {
			let contents = try fileManager.contentsOfDirectory(
				at: url,
				includingPropertiesForKeys: nil,
				options: .skipsHiddenFiles
			)
			for item in contents {
				let entity = try getEntity(from: item)
				files.append(entity)
			}
		} else {
			let entity = try getEntity(from: url)
			files.append(entity)
		}
		return files.compactMap { $0 }
	}
}
