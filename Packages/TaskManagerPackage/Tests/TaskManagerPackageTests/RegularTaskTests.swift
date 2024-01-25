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
		let sut = RegularTask(title: taskTitle, completed: true)

		XCTAssertEqual(sut.title, "RegularTask", "Неверно установлен title (Наименование задания).")
		XCTAssertTrue(sut.completed, "Задание ожидалось создаться выполненным")
	}

	func test_initialization_propertyCompletedShouldBeFalse() {
		let sut = RegularTask(title: taskTitle)

		XCTAssertFalse(sut.completed, "Неверно установлено свойство completed (Состояние задания).")
	}

	func test_togglePropertyCompleted_propertyCompletedShouldBeTrue() {
		let sut = RegularTask(title: taskTitle)

		sut.completed.toggle()

		XCTAssertTrue(sut.completed, "Невозможно завершить задание.")
	}

}

// MARK: - TestData
private extension RegularTaskTests {
	var taskTitle: String {
		"RegularTask"
	}
}
