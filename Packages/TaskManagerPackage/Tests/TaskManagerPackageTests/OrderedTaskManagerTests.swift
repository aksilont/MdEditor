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
	private var taskManager: ITaskManager!
	private var tasks: [Task]!
	private var importantTaskWithHighPriority: Task!

	override func setUp() {
		super.setUp()

		importantTaskWithHighPriority = ImportantTask(title: "Do homework", taskPriority: .high)
		tasks = [
			RegularTask(title: "Do Workout", completed: true),
			importantTaskWithHighPriority,
			ImportantTask(title: "Write new tasks", taskPriority: .low),
			RegularTask(title: "Solve 3 algorithms"),
			ImportantTask(title: "Go shopping", taskPriority: .medium),
		]
		taskManager = TaskManager(taskList: tasks)
		sut = OrderedTaskManager(taskManager: taskManager)
	}

	override func tearDown(){
		tasks = nil
		taskManager = nil
		sut = nil
		importantTaskWithHighPriority = nil

		super.tearDown()
	}

	func test_allTasks_shouldBe5TasksOrderedByPriority() {
		let allTasks = sut.allTasks()

		XCTAssertFalse(allTasks.isEmpty, "Список заданий пуст.")
		XCTAssertEqual(allTasks.count, 5, "Список заданий содержит больше/меньше 5 заданий.")
		XCTAssertEqual(
			sut.allTasks(),
			sorted(tasks: taskManager.allTasks()),
			"Задания в списке не отсортированы по приоритету."
		)
	}

	func test_completedTasks_shouldBeCompletedTasksOrderedByPriority() {
		importantTaskWithHighPriority.completed = true

		let completedTasks = sut.completedTasks()

		XCTAssertFalse(completedTasks.isEmpty, "Список заданий пуст.")
		XCTAssertEqual(completedTasks.count, 2, "Список заданий содержит больше/меньше 2 заданий.")
		XCTAssertEqual(
			sut.completedTasks(),
			sorted(tasks: taskManager.completedTasks()),
			"Выполненные задания в списке не отсортированы по приоритету."
		)
	}

	func test_uncompletedTasks_shouldBeUncompletedTasksOrderedByPriority() {
		let uncompletedTasks = sut.uncompletedTasks()

		XCTAssertFalse(uncompletedTasks.isEmpty, "Список заданий пуст.")
		XCTAssertEqual(uncompletedTasks.count, 4, "Список заданий содержит больше/меньше 4 заданий.")
		XCTAssertEqual(
			sut.uncompletedTasks(),
			sorted(tasks: taskManager.uncompletedTasks()),
			"Задания для выполнения в списке не отсортированы по приоритету."
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
