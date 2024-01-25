//
//  TaskManagerTests.swift
//  
//
//  Created by Денис Васильев on 08.01.2024.
//

import XCTest
@testable import TaskManagerPackage

final class TaskManagerTests: XCTestCase {

	private let regularTask = RegularTask(title: "Regular Task", completed: true)
	private let importantTask = ImportantTask(title: "Important Low Task", taskPriority: .low)

	func test_allTasks_add2Tasks_shouldBe2Tasks() {
		let sut = makeSut()
		let tasks = [regularTask, importantTask]
		sut.addTasks(tasks: tasks)

		let allTasks = sut.allTasks()

		XCTAssertFalse(allTasks.isEmpty, "Список заданий пуст.")
		XCTAssertEqual(allTasks.count, 2, "Список заданий содержит больше/меньше 2 заданий.")
	}

	func test_completedTasks_add1CompletedTask_shouldBe1CompletedTask() {
		let sut = makeSut()
		sut.addTask(task: regularTask)

		let completedTasks = sut.completedTasks()
		XCTAssertFalse(completedTasks.isEmpty, "Список выполненных заданий пуст.")
		XCTAssertEqual(completedTasks.count, 1, "Список выполненных заданий содержит больше 1 задания.")
		XCTAssertTrue(
			completedTasks.contains(regularTask),
			"В списке выполненных заданий отсутствует завершенное задание."
		)
	}

	func test_completedTasks_add1CompletedAnd1UncompletedTasks_shouldBe1CompletedTask() {
		let sut = makeSut()
		let tasks = [regularTask, importantTask]
		sut.addTasks(tasks: tasks)

		let completedTasks = sut.completedTasks()

		XCTAssertFalse(completedTasks.isEmpty, "Список выполненных заданий пуст.")
		XCTAssertEqual(completedTasks.count, 1, "Список выполненных заданий содержит больше 1 задания.")
		XCTAssertTrue(
			completedTasks.contains(regularTask),
			"В списке выполненных заданий отсутствует завершенное задание."
		)
		XCTAssertFalse(
			completedTasks.contains(importantTask),
			"Список выполненных заданий содержит незавершенное задание."
		)
	}

	func test_uncompletedTasks_add1UncompletedTask_shouldBe1UncompletedTask() {
		let sut = makeSut()
		sut.addTask(task: importantTask)

		let uncompletedTasks = sut.uncompletedTasks()

		XCTAssertFalse(uncompletedTasks.isEmpty, "Список заданий для выполнения пуст.")
		XCTAssertEqual(uncompletedTasks.count, 1, "Список заданий для выполнения содержит больше 1 задания.")
		XCTAssertTrue(
			uncompletedTasks.contains(importantTask),
			"В списке заданий для выполнения отсутствует незавершенное задание."
		)
	}

	func test_uncompletedTasks_add1CompletedAnd1UncompletedTasks_shouldBe1UncompletedTask() {
		let sut = makeSut()
		let tasks = [regularTask, importantTask]
		sut.addTasks(tasks: tasks)

		let uncompletedTasks = sut.uncompletedTasks()

		XCTAssertFalse(uncompletedTasks.isEmpty, "Список заданий для выполнения пуст.")
		XCTAssertEqual(uncompletedTasks.count, 1, "Список заданий для выполнения содержит больше 1 задания.")
		XCTAssertTrue(
			uncompletedTasks.contains(importantTask),
			"В списке заданий для выполнения отсутствует незавершенное задание."
		)
		XCTAssertFalse(
			uncompletedTasks.contains(regularTask),
			"Список заданий для выполнения содержит завершенное задание."
		)
	}

	func test_addTask_add1Task_shouldBe1Task() {
		let sut = makeSut()

		sut.addTask(task: regularTask)
		let allTasks = sut.allTasks()

		XCTAssertFalse(allTasks.isEmpty, "Список заданий пуст.")
		XCTAssertEqual(allTasks.count, 1, "Список заданий содержит больше 1 задания.")
		XCTAssertTrue(allTasks.contains(regularTask), "Данное задание отсутствует.")
	}

	func test_addTasks_add2Tasks_shouldBe2Tasks() {
		let sut = makeSut()
		let tasks = [regularTask, importantTask]

		sut.addTasks(tasks: tasks)
		let allTasks = sut.allTasks()

		XCTAssertFalse(allTasks.isEmpty, "Список заданий пуст.")
		XCTAssertEqual(allTasks.count, 2, "Список заданий содержит больше/меньше 2 заданий.")
		XCTAssertTrue(allTasks.contains(regularTask), "Обычное (regular) задание отсутствует.")
		XCTAssertTrue(allTasks.contains(importantTask), "Важное (important) задание отсутствует.")
		XCTAssertEqual(allTasks, [regularTask, importantTask], "Задания добавлены в неверном порядке.")
	}

	func test_removeTask_add2TasksAndRemove1Task_shouldBe1Task() {
		let sut = makeSut()
		let tasks = [regularTask, importantTask]
		sut.addTasks(tasks: tasks)

		sut.removeTask(task: regularTask)
		let allTasks = sut.allTasks()

		XCTAssertNotEqual(allTasks, tasks, "В списке заданий те же задачи, что и до удаления.")
		XCTAssertEqual(allTasks.count, 1, "Список заданий содержит больше/меньше 1 задания.")
		XCTAssertFalse(allTasks.contains(regularTask), "В списке заданий присутствует удаленное задание.")
	}

}

// MARK: - TestData

private extension TaskManagerTests {
	func makeSut() -> TaskManager {
		TaskManager()
	}
}
