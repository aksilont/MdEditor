//
//  TodoListCoordinator.swift
//  MdEditor
//

import UIKit
import TaskManagerPackage

final class TodoListCoordinator: ICoordinator {
	// MARK: - Dependencies
	private let navigationController: UINavigationController

	// MARK: - Initialization
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	// MARK: - Internal methods
	func start() {
		showTodoListScene()
	}

	// MARK: - Private methods
	private func showTodoListScene() {
		let assembler = TodoListAssembler(taskManager: buildTaskManager())
		let viewController = assembler.assembly()
		navigationController.pushViewController(viewController, animated: true)
	}

	private func buildTaskManager() -> ITaskManager {
		let taskManager = TaskManager()
		var repository: ITaskRepository
		if CommandLine.isUITesting {
			repository = TaskRepositoryStub()
		} else {
			repository = TaskRepositoryStub() // В реальной ситуации данные подгружаются из хранилища или сети
		}
		let orderedTaskManager = OrderedTaskManager(taskManager: taskManager)
		orderedTaskManager.addTasks(tasks: repository.getTasks())

		return orderedTaskManager
	}
}
