//
//  RegularTaskTests.swift
//  
//
//  Created by Денис Васильев on 08.01.2024.
//

import XCTest
@testable import TaskManagerPackage

final class RegularTaskTests: XCTestCase {

	func test_initialization_titleIsSet_shouldHaveCorrectTitle() {
		let sut = makeSut()

		XCTAssertEqual(sut.title, "RegularTask", "Неверно установлен title (Наименование задания).")
	}

	func test_initialization_propertyCompletedShouldBeFalse() {
		let sut = makeSut()

		XCTAssertFalse(sut.completed, "Неверно установлено свойство completed (Состояние задания).")
	}

	func test_togglePropertyCompleted_propertyCompletedShouldBeTrue() {
		let sut = makeSut()

		sut.completed.toggle()

		XCTAssertTrue(sut.completed, "Невозможно завершить задание.")
	}

}

// MARK: - TestData

private extension RegularTaskTests {
	func makeSut() -> RegularTask {
		RegularTask(title: "RegularTask")
	}
}
