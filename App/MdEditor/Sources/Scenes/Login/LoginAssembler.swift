//
//  LoginAssembler.swift
//  MdEditor
//
//  Created by Kirill Leonov on 04.12.2023.
//

import UIKit

final class LoginAssembler {
	/// Сборка модуля авторизации
	/// - Parameter loginResultClosure: замыкание оповещающие о результате авторизации
	/// - Returns: вью
	func assembly(loginResultClosure: LoginResultClosure?) -> LoginViewController {
		let viewController = LoginViewController()
		let presenter = LoginPresenter(viewController: viewController, loginResultClosure: loginResultClosure)
		let worker: ILoginWorker
		if LaunchArguments[.isUITesting] {
			worker = StubLoginWorker()
		} else {
			worker = LoginWorker()
		}
		let interactor = LoginInteractor(presenter: presenter, worker: worker)
		viewController.interactor = interactor

		return viewController
	}
}
