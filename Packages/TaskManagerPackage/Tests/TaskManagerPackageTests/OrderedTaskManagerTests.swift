//
//  OrderedTaskManagerTests.swift
//  
//
//  Created by Денис Васильев on 08.01.2024.
//

import XCTest
@testable import TaskManagerPackage

final class OrderedTaskManagerTests: XCTestCase {

	private var sut: ITaskManager!

	override func setUp() {
		super.setUp()
		sut = makeSUT()
	}

	func test_allTasks_shouldBe5TasksOrderedByPriority() {
		let allTasks = TasksStub.orderedAllTasks

		XCTAssertFalse(allTasks.isEmpty, "Список не должен быть пуст.")
		XCTAssertEqual(allTasks.count, 5, "Список заданий должен содержать 5 заданий")
		XCTAssertEqual(
			sut.allTasks(),
			allTasks,
			"Задания в списке должны быть отсортированы по приоритету."
		)
	}

	func test_completedTasks_shouldBe2CompletedTasksOrderedByPriority() {
		let completedTasks = sut.completedTasks()

		XCTAssertFalse(completedTasks.isEmpty, "Список не должен быть пуст.")
		XCTAssertEqual(completedTasks.count, 2, "Список заданий должен содержать 2 задания.")
		XCTAssertEqual(
			sut.completedTasks(),
			TasksStub.orderedCompletedTasks,
			"Выполненные задания в списке должны быть отсортированы по приоритету."
		)
	}

	func test_uncompletedTasks_shouldBe3UncompletedTasksOrderedByPriority() {
		let uncompletedTasks = sut.uncompletedTasks()

		XCTAssertFalse(uncompletedTasks.isEmpty, "Список заданий не должен быть пуст.")
		XCTAssertEqual(uncompletedTasks.count, 3, "Список заданий должен содержать 4 задания.")
		XCTAssertEqual(
			sut.uncompletedTasks(),
			TasksStub.orderedUncompletedTasks,
			"Задания для выполнения в списке должны быть отсортированы по приоритету."
		)
	}

}

// MARK: - Private methods

private extension OrderedTaskManagerTests {
	func sorted(tasks: [Task]) -> [Task] {
		tasks.sorted {
			if let task0 = $0 as? ImportantTask, let task1 = $1 as? ImportantTask {
				return task0.taskPriority.rawValue > task1.taskPriority.rawValue
			}
			if $0 is ImportantTask, $1 is RegularTask {
				return true
			}
			return false
		}
	}
}

private extension OrderedTaskManagerTests {
	enum TasksStub {
		static let orderedAllTasks = [
			MockTaskManager.highImportantTask,
			MockTaskManager.mediumImportantTask,
			MockTaskManager.lowImportantTask,
			MockTaskManager.completedRegularTask,
			MockTaskManager.uncompletedRegularTask
		]

		static let orderedCompletedTasks = [
			MockTaskManager.mediumImportantTask,
			MockTaskManager.completedRegularTask
		]

		static let orderedUncompletedTasks = [
			MockTaskManager.highImportantTask,
			MockTaskManager.lowImportantTask,
			MockTaskManager.uncompletedRegularTask
		]
	}

	func makeSUT() -> OrderedTaskManager {
		let mockTaskManager = MockTaskManager()
		let sut = OrderedTaskManager(taskManager: mockTaskManager)
		return sut
	}
}
