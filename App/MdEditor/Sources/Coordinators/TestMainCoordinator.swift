//
//  TestMainCoordinator.swift
//  MdEditor
//
//  Created by Aksilont on 04.03.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

final class TestCoordinator: BaseCoordinator {
	// MARK: - Dependencies
	private let navigationController: UINavigationController

	// MARK: - Initialization
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	// MARK: - Internal methods
	override func start() {
		if LaunchArguments[.isUITesting] {
			UIView.setAnimationsEnabled(false)
		}

		if LaunchArguments[.runEditorFlow] {
			runEditorFlow()
		} else if LaunchArguments[.runTodoListFlow] {
			runTodoListFlow()
		} else {
			runLoginFlow()
		}
	}
}

// MARK: - Private methods
private extension TestCoordinator {
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
