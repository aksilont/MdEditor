//
//  LoginUITests.swift
//  MdEditorUITests
//

import XCTest

final class LoginUITests: XCTestCase {

	func test_login_withValidCred_mustBeSuccess() {
		let app = XCUIApplication()
		let loginScreen = LoginScreenObject(app: app)
		let todoScreen = TodoListScreenObject(app: app)
		app.launch()

		loginScreen
			.isLoginScreen()
			.set(login: "Admin")
			.set(password: "pa$$32!")
			.login()

		todoScreen
			.isTodoListScreen()
	}

	func test_login_withInValidCred_mustBeShowAlert() {
		let app = XCUIApplication()
		let loginScreen = LoginScreenObject(app: app)
		app.launch()

		loginScreen
			.isLoginScreen()
			.set(password: "user")
			.set(login: "wrongPass")
			.login()
			.closeAlert()
	}
}
