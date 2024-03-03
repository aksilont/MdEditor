//
//  MainCoordinator.swift
//  MdEditor
//

import UIKit

final class MainCoordinator: BaseCoordinator {
	// MARK: - Dependencies
	private let navigationController: UINavigationController

	// MARK: - Initialization
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	// MARK: - Internal methods
	override func start() {
#if DEBUG
		if CommandLine.skipLogin {
			runTodoListFlow()
			return
		}
#endif
		runLoginFlow()
	}
}

// MARK: - Private methods
private extension MainCoordinator {
	func runLoginFlow() {
		let coordinator = LoginCoordinator(navigationController: navigationController)
		addDependency(coordinator)

		coordinator.finishFlow = { [weak self, weak coordinator] in
			self?.runEditorFlow()
			coordinator.map { self?.removeDependency($0) }
		}

		coordinator.start()
	}

	func runEditorFlow() {
		let coordinator = EditorCoordinator(navigationController: navigationController)
		addDependency(coordinator)
		coordinator.start()
	}

	func runTodoListFlow() {
		let coordinator = TodoListCoordinator(navigationController: navigationController)
		addDependency(coordinator)
		coordinator.start()
	}
}
