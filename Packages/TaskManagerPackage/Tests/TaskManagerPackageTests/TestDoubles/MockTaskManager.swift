//
//  MockTaskManager.swift
//  
//
//  Created by Константин Натаров on 23.01.2024.
//

import Foundation
@testable import TaskManagerPackage

final class MockTaskManager: ITaskManager {
	static let highImportantTask = ImportantTask(title: "highImportantTask", taskPriority: .high)
	static let mediumImportantTask: ImportantTask = {
		var task = ImportantTask(title: "mediumImportantTask", taskPriority: .medium)
		task.completed = true
		return task
	}()
	static let lowImportantTask = ImportantTask(title: "lowImportantTask", taskPriority: .low)
	static let completedRegularTask = RegularTask(title: "completedRegularTask", completed: true)
	static let uncompletedRegularTask = RegularTask(title: "regularTask")

	func allTasks() -> [TaskManagerPackage.Task] {
		[
			MockTaskManager.mediumImportantTask,
			MockTaskManager.highImportantTask,
			MockTaskManager.lowImportantTask,
			MockTaskManager.completedRegularTask,
			MockTaskManager.uncompletedRegularTask
		]
	}

	func completedTasks() -> [TaskManagerPackage.Task] {
		[
			MockTaskManager.completedRegularTask,
			MockTaskManager.mediumImportantTask
		]
	}

	func uncompletedTasks() -> [TaskManagerPackage.Task] {
		[
			MockTaskManager.uncompletedRegularTask,
			MockTaskManager.highImportantTask,
			MockTaskManager.lowImportantTask
		]
	}

	func addTasks(tasks: [TaskManagerPackage.Task]) {
		fatalError("Not implimented!")
	}

	func addTask(task: TaskManagerPackage.Task) {
		fatalError("Not implimented!")
	}

	func removeTask(task: TaskManagerPackage.Task) {
		fatalError("Not implimented!")
	}
}
