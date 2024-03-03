//
//  RecentFileManagerTests.swift
//  MdEditorTests
//
//  Created by Aksilont on 03.03.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import XCTest
@testable import MdEditor

final class RecentFileManagerTests: XCTestCase {
	func test_assets_getRecentFilesAfterClearShouldHaveZeroItems() async {
		let sut = makeSut()
		let numberItemsOfFetch = 0

		sut.clearRecentFiles()
		let files = sut.getRecentFiles()

		XCTAssertEqual(files.count, numberItemsOfFetch, "Service should return \(numberItemsOfFetch) recent items")
	}

	func test_assets_addToSameFiles_mangerShouldReturnSingleItem() async {
		let sut = makeSut()
		let numberItemsOfFetch = 1

		sut.clearRecentFiles()
		sut.addToRecentFiles(TestingData.file1)
		sut.addToRecentFiles(TestingData.file1)
		sut.addToRecentFiles(TestingData.file1)
		let files = sut.getRecentFiles()

		XCTAssertEqual(files.count, numberItemsOfFetch, "Service should return \(numberItemsOfFetch) recent items")
	}

	@MainActor
	func test_assets_addToRecentFilesShouldReturnItems() async {
		let sut = makeSut()
		let numberItemsOfFetch = 2

		sut.clearRecentFiles()
		sut.addToRecentFiles(TestingData.file1)
		sut.addToRecentFiles(TestingData.file2)
		let files = sut.getRecentFiles()

		XCTAssertEqual(files.count, numberItemsOfFetch, "Service should return \(numberItemsOfFetch) recent items")
	}

	@MainActor
	func test_assets_deleteRecentFile_shouldReturnZeroItems() async {
		let sut = makeSut()
		let numberItemsOfFetch = 1

		sut.clearRecentFiles()
		sut.addToRecentFiles(TestingData.file1)
		sut.addToRecentFiles(TestingData.file2)
		sut.deleteRecentFile(TestingData.file1)
		let files = sut.getRecentFiles()

		XCTAssertEqual(files.count, numberItemsOfFetch, "Service should return \(numberItemsOfFetch) recent items")
	}
}

private extension RecentFileManagerTests {
	enum TestingData {
		static let key = String(describing: RecentFileManagerTests.self)
		static let file1 = FileSystemEntity()
		static let file2 = FileSystemEntity()
	}

	func makeSut() -> RecentFileManager {
		return RecentFileManager(key: TestingData.key)
	}
}
