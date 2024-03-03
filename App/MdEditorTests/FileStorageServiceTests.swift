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

		let result = await sut.fetchData(of: source)
		let files = try? result.get()
		let fileName = files?.first?.fullName ?? ""

		XCTAssertEqual(
			fileName,
			TestingData.sourceAboutFileName,
			"Directory Assets should contain \"\(TestingData.sourceAboutFileName)\""
		)
	}

	func test_about_shouldContainsSpecialText() {
		let sut = makeSut()
		let source = TestingData.sourceAboutFile
		let necesseryText = TestingData.aboutNecesseryText

		let string = sut.loadFile(from: source)
		let checkContains = string.contains(necesseryText)

		XCTAssertTrue(
			checkContains,
			"\(TestingData.sourceAboutFileName) should contain necessery text \"\(necesseryText)\""
		)
	}

	@MainActor
	func test_assets_fetchRootUrlsShouldHaveItems() async {
		let sut = makeSut()
		let source = TestingData.rootUrls
		let correctNumber = source.count

		let result = await sut.fetchData(of: nil)
		let files = try? result.get()

		XCTAssertEqual(files?.count, correctNumber, "Service should return \(correctNumber) roots items")
	}

	@MainActor
	func test_assets_fetchAssetsDirectoryShouldHaveNestedItems() async {
		let sut = makeSut()
		let sourceAssets = TestingData.sourceAssetsDirectory

		let result = await sut.fetchData(of: sourceAssets)

		XCTAssertNoThrow(try result.get(), "Service should fetch directory Assets without any errors")

		let nestedItems = try? result.get()
		XCTAssertGreaterThan(nestedItems?.count ?? 0, 0, "Count of files in directory Assets should be more than 0")
	}
}

private extension FileStorageServiceTests {
	enum TestingData {
		static let aboutNecesseryText = "MdEditor — Текстовый редактор"
		static let mainBundle = ResourcesBundle.bundle
		static let sourceAssetsDirectory = mainBundle.appendingPathComponent(ResourcesBundle.assets)
		static let sourceAboutFile = mainBundle.appendingPathComponent(ResourcesBundle.about)
		static let sourceAboutFileName = ResourcesBundle.about
		static let rootUrls = ResourcesBundle.defaultUrls
	}

	func makeSut() -> IStorageService {
		let sut = FileStorageService(
			fileManager: FileManager.default,
			defaultURL: TestingData.rootUrls
		)
		return sut
	}
}
