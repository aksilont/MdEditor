//
//  RecentFileManager.swift
//  MdEditor
//
//  Created by Aksilont on 21.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

/// Показывает последние файлы
protocol IRecentFileManager {
	/// Предоставляет список файлов
	/// - Returns: массив системных файлов
	func getRecentFiles() -> [FileSystemEntity]

	/// Добавляет файл к списку последних файлов
	/// - Parameter file: системный файл
	func addToRecentFiles(_ file: FileSystemEntity)
	
	/// Очищает список последних файлов
	func clearRecentFiles()

	/// Удаляет указанный системный файл из списка последних файлов
	/// - Parameter file: системный файл
	func deleteRecentFile(_ file: FileSystemEntity)
}

final class RecentFileManager: IRecentFileManager {
	// MARK: - Private properties
	private let userDefaults: UserDefaults
	private let key: String
	private let countOfShowItems: Int

	// MARK: - Initialization
	init(userDefaults: UserDefaults = UserDefaults.standard, key: String, countOfShowItems: Int = 5) {
		self.userDefaults = userDefaults
		self.key = key
		self.countOfShowItems = countOfShowItems
	}

	// MARK: - Public methods
	func getRecentFiles() -> [FileSystemEntity] {
		return getRecentFiles(all: false)
	}

	func addToRecentFiles(_ file: FileSystemEntity) {
		var recentFiles = getRecentFiles(all: true)
		if let index = recentFiles.firstIndex(of: file) {
			recentFiles.move(fromOffsets: IndexSet(integer: index), toOffset: 0)
		} else {
			recentFiles.insert(file, at: 0)
		}

		guard let encodedData = try? JSONEncoder().encode(recentFiles) else { return }
		userDefaults.setValue(
			encodedData,
			forKey: key
		)
	}

	func clearRecentFiles() {
		userDefaults.removeObject(forKey: key)
	}

	func deleteRecentFile(_ file: FileSystemEntity) {
		var recentFiles = getRecentFiles(all: true)
		recentFiles.removeAll(where: { $0 == file })

		guard let encodedData = try? JSONEncoder().encode(recentFiles) else { return }
		userDefaults.setValue(
			encodedData,
			forKey: key
		)
	}
}

// MARK: - Private methods
private extension RecentFileManager {
	func getRecentFiles(all: Bool) -> [FileSystemEntity] {
		guard let data = userDefaults.data(forKey: key),
			  let decodedItems = try? JSONDecoder().decode([FileSystemEntity].self, from: data) else {
			return []
		}
		let result = decodedItems.compactMap { $0 }
		guard all else { return Array(result.prefix(countOfShowItems)) }
		return result
	}
}
