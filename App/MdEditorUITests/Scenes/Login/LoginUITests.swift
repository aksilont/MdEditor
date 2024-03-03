//
//  LoginUITests.swift
//  MdEditorUITests
//

import XCTest

final class LoginUITests: XCTestCase {
	func test_login_withValidCredentials_mustBeSuccess() {
		let (sut, app) = makeSUT()
		sut
			.isLoginScreen()
			.set(login: LoginCredentials.valid.login)
			.set(password: LoginCredentials.valid.password)
			.login()

		StartScreenObject(app: app)
			.isStartScreen()
	}

	func test_login_withInvalidCredentials_mustBeShowAlert() {
		let (sut, _) = makeSUT()
		sut
			.isLoginScreen()
			.set(login: LoginCredentials.invalid.login)
			.set(password: LoginCredentials.invalid.password)
			.login()
			.closeAlert()
	}
}

// MARK: - Private Extension
private extension LoginUITests {
	/// Тестовые данные
	enum LoginCredentials {
		static let valid: (login: String, password: String) = ("Login", "Password")
		static let invalid: (login: String, password: String) = ("wrongLogin", "wrongPass")
	}

	/// Создать и подготовить объект-приложение для тестирования
	func makeSUT() -> (LoginScreenObject, XCUIApplication) {
		let app = XCUIApplication()
		let screen = LoginScreenObject(app: app)
		app.launchArguments.append(LaunchArguments.isUItesting)
		app.launch()

		return (screen, app)
	}
}
