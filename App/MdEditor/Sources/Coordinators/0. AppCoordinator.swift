//
//  AppCoordinator.swift
//  MdEditor
//

import UIKit

final class AppCoordinator: BaseCoordinator {
	// MARK: - Private properties
	private let navigationController: UINavigationController

	// MARK: - Initialization
	init(window: UIWindow?) {
		self.navigationController = UINavigationController()

		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
	}
	
	// MARK: - Internal methods
	override func start() {
#if DEBUG
		let coordinator = TestCoordinator(navigationController: navigationController)
#else
		let coordinator = MainCoordinator(navigationController: navigationController)
#endif
		addDependency(coordinator)
		coordinator.start()
	}
}
