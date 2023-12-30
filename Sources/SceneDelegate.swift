//
//  SceneDelegate.swift
//

import UIKit
import TaskManagerPackage
import DataStructuresPackage

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?
	
	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: windowScene)

		/// Проверка подключения пакетов
		_ = TaskManager()
		_ = DoublyLinkedList<Int>()
		_ = Queue<Int>()

		window.rootViewController = ViewController()
		window.makeKeyAndVisible()
		self.window = window
	}
}
