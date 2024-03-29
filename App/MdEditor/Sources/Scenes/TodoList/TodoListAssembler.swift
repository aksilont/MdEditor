//
//  TodoListAssembler.swift
//  MdEditor
//
//  Created by Kirill Leonov on 04.12.2023.
//

import UIKit
import TaskManagerPackage

final class TodoListAssembler {

	// MARK: - Dependencies

	private let taskManager: ITaskManager

	// MARK: - Initialization
	
	/// Инициализатор сборщика модуля списка заданий.
	/// - Parameters:
	///   - taskManager: Менеджер заданий.
	init(taskManager: ITaskManager) {
		self.taskManager = taskManager
	}

	// MARK: - Public methods

	/// Сборка модуля списка заданий.
	/// - Parameter createTaskClosure: замыкание оповещающие о инициации создания заданий.
	/// - Returns: TodoListViewController с проставленными зависимостями VIP цикла.
	func assembly() -> TodoListViewController {
		let viewController = TodoListViewController()
		let sectionForTaskManagerAdapter = SectionForTaskManagerAdapter(taskManager: taskManager)
		let presenter = TodoListPresenter(viewController: viewController)
		let interactor = TodoListInteractor(presenter: presenter, sectionManager: sectionForTaskManagerAdapter)
		viewController.interactor = interactor

		return viewController
	}
}
