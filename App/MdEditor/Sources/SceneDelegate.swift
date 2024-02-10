//
//  SceneDelegate.swift
//

import UIKit
import TaskManagerPackage

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?
	private var appCoordinator: ICoordinator! // swiftlint:disable:this implicitly_unwrapped_optional

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let scene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: scene)

		appCoordinator = AppCoordinator(
			window: window,
			taskManager: buildTaskManager(),
			storage: buildStorage()
		)
		appCoordinator.start()

		self.window = window
	}

	// MARK: - Private methods

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

	private func buildStorage() -> IStorageService {
		FileStorageService()
	}
}
