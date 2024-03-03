//
//  AppCoordinator.swift
//  MdEditor
//

import UIKit

final class AppCoordinator: BaseCoordinator {
	// MARK: - Dependencies
	private let navigationController: UINavigationController
	private let window: UIWindow?

	// MARK: - Initialization
	init(window: UIWindow?) {
		self.navigationController = UINavigationController()

		self.window = window
		self.window?.rootViewController = navigationController
		self.window?.makeKeyAndVisible()
	}
	
	// MARK: - Internal methods
	override func start() {
		runMainFLow()
	}
}

// MARK: - Private methods
private extension AppCoordinator {
	func runMainFLow() {
		let coordinator = MainCoordinator(navigationController: navigationController)
		addDependency(coordinator)
		coordinator.start()
	}
}
