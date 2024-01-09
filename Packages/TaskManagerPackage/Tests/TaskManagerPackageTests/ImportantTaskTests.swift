//
//  ImportantTaskTests.swift
//  
//
//  Created by Денис Васильев on 08.01.2024.
//

import XCTest
@testable import TaskManagerPackage

final class ImportantTaskTests: XCTestCase {

	func test_createImportantTask_initializationShouldBeValid() {
		let title = "ImportantTask"
		let taskPriority = ImportantTask.TaskPriority.low

		let sut = ImportantTask(title: title, taskPriority: taskPriority)

		XCTAssertEqual(sut.title, title, "После создания важного задания происходит подмена ее названия.")
		XCTAssertEqual(
			sut.taskPriority,
			taskPriority,
			"После создания важного задания происходит подмена ее приоритета."
		)
	}

	func test_initialization_propertyCompletedShouldBeFalse() {
		let sut = ImportantTask(title: "ImportantTask", taskPriority: .low)

		XCTAssertFalse(sut.completed, "Неверно установлено свойство completed (Состояние задания).")
	}

	func test_togglePropertyCompleted_propertyCompletedShouldBeTrue() {
		let sut = ImportantTask(title: "ImportantTask", taskPriority: .low)

		sut.completed.toggle()

		XCTAssertTrue(sut.completed, "Невозможно завершить задание.")
	}

	func test_createImportantTask_withLowPriority_deadlineShouldBeIn3Days() {
		let createDate = Date()
		let sut = ImportantTask(title: "ImportantTask", taskPriority: .low, createDate: createDate)

		let deadline = Calendar.current.date(byAdding: .day, value: 3, to: createDate)

		XCTAssertEqual(sut.deadLine, deadline, "Deadline для задания с приоритетом Low не равен 3-м дням.")
	}

	func test_createImportantTask_withMediumPriority_deadlineShouldBeIn2Days() {
		let createDate = Date()
		let sut = ImportantTask(title: "ImportantTask", taskPriority: .medium, createDate: createDate)

		let deadline = Calendar.current.date(byAdding: .day, value: 2, to: createDate)

		XCTAssertEqual(sut.deadLine, deadline, "Deadline для задания с приоритетом Low не равен 2-м дням.")
	}

	func test_createImportantTask_withHighPriority_deadlineShouldBeIn1Days() {
		let createDate = Date()
		let sut = ImportantTask(title: "ImportantTask", taskPriority: .high, createDate: createDate)

		let deadline = Calendar.current.date(byAdding: .day, value: 1, to: createDate)

		XCTAssertEqual(sut.deadLine, deadline, "Deadline для задания с приоритетом Low не равен 1-му дню.")
	}
}
