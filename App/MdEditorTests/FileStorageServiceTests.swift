//
//  FileStorageServiceTests.swift
//  MdEditorTests
//
//  Created by Aksilont on 09.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import XCTest
@testable import MdEditor

final class FileStorageServiceTests: XCTestCase {

	@MainActor
	func test_assets_shouldHaveAboutFile() async {
		let sut = makeSut()
		let source = TestingData.sourceAboutFile

		let result = await sut.fetchData(urls: [source])
		let files = try? result.get()
		let fileName = files?.first?.fullName ?? ""

		XCTAssertEqual(fileName, ResourcesBundle.about, "Directory Assets should contain \"\(ResourcesBundle.about)\"")
	}

	@MainActor
	func test_about_shouldContainsSpecialText() async {
		let sut = makeSut()
		let source = TestingData.sourceAboutFile
		let necesseryText = TestingData.aboutNecesseryText

		let string = await sut.loadFileBody(url: source)
		let checkContains = string.contains(necesseryText)

		XCTAssertTrue(checkContains, "About.md should contain necessery text \"\(necesseryText)\"")
	}

	@MainActor
	func test_assets_fetchRootUrlsShouldHaveItems() async {
		let sut = makeSut()
		let source = TestingData.rootUrls
		let correctNumber = source.count

		let result = await sut.fetchData(urls: source)
		let files = try? result.get()

		XCTAssertEqual(files?.count, correctNumber, "Service should return \(correctNumber) roots items")
	}

	@MainActor
	func test_assets_fetchRecentFilesShouldHaveItems() async {
		let sut = makeSut()
		let sources = TestingData.rootUrls
		let numberItemsOfFetch = 5

		let result = await sut.fetchRecent(count: numberItemsOfFetch, with: sources)
		let files = try? result.get()

		XCTAssertEqual(files?.count, numberItemsOfFetch, "Service should return \(numberItemsOfFetch) recent items")
	}

	@MainActor
	func test_assets_fetchAssetsDirectoryShouldHaveNestedItems() async {
		let sut = makeSut()
		let sourceAssets = TestingData.sourceAssetsDirectory

		let result = await sut.fetchData(urls: [sourceAssets])

		XCTAssertNoThrow(try result.get(), "Service should fetch directory Assets without any errors")

		let nestedItems = try? result.get()
		XCTAssertGreaterThan(nestedItems?.count ?? 0, 0, "Count of files in directory Assets should be more than 0")
	}
}

private extension FileStorageServiceTests {
	enum TestingData {
		static let aboutNecesseryText = "MdEditor — Текстовый редактор"
		static let mainBundle = Bundle.main.bundleURL
		static let sourceAssetsDirectory = mainBundle.appendingPathComponent(ResourcesBundle.assets)
		static let sourceAboutFile = sourceAssetsDirectory.appendingPathComponent(ResourcesBundle.about)
		static let rootUrls = ResourcesBundle.defaultsUrls
	}

	func makeSut() -> IStorageService {
		let sut = FileStorageService()
		return sut
	}
}
