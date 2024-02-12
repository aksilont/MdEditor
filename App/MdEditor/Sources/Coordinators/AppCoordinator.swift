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
	private let storage: IStorageService

	// MARK: - Initialization

	init(window: UIWindow?, taskManager: ITaskManager, storage: IStorageService) {
		self.navigationController = UINavigationController()

		self.window = window
		self.window?.rootViewController = navigationController
		self.window?.makeKeyAndVisible()

		self.taskmanager = taskManager
		self.storage = storage
	}
	
	// MARK: - Internal methods

	override func start() {
		runMainFLow()
	}

	func runMainFLow() {
		let coordinator = MainCoordinator(
			navigationController: navigationController,
			taskManager: taskmanager,
			storage: storage
		)
		addDependency(coordinator)
		coordinator.start()
	}
}
