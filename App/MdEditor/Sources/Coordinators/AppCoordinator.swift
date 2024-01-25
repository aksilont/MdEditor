//
//  AppCoordinator.swift
//  MdEditor
//

import UIKit
import TaskManagerPackage

final class AppCoordinator: BaseCoordinator {

	// MARK: - Dependencies

	private let navigationController: UINavigationController
	private let window: UIWindow?
	private let taskmanager: ITaskManager

	// MARK: - Initialization

	init(window: UIWindow?, taskManager: ITaskManager) {
		self.navigationController = UINavigationController()

		self.window = window
		self.window?.rootViewController = navigationController
		self.window?.makeKeyAndVisible()

		self.taskmanager = taskManager
	}
	
	// MARK: - Internal methods

	override func start() {
		runMainFLow()
	}

	func runMainFLow() {
		let coordinator = MainCoordinator(navigationController: navigationController, taskManager: taskmanager)
		addDependency(coordinator)
		coordinator.start()
	}
}
