//
//  LoginScreenObject.swift
//  MdEditorUITests
//

import XCTest

final class LoginScreenObject: BaseScreenObject {

	// MARK: - Private properties

	private lazy var textFieldLogin = app.textFields[AccessibilityIdentifier.Login.textFieldLogin.description]
	private lazy var textFieldPass = app.secureTextFields[AccessibilityIdentifier.Login.textFieldPass.description]
	private lazy var buttonLogin = app.buttons[AccessibilityIdentifier.Login.buttonLogin.description]
	private lazy var alert = app.alerts.firstMatch

	// MARK: - ScreenObject Methods

	@discardableResult
	func isLoginScreen() -> Self {
		assert(textFieldLogin, [.exists])
		assert(textFieldPass, [.exists])
		assert(buttonLogin, [.exists])

		return self
	}

	@discardableResult
	func set(login: String) -> Self {
		assert(textFieldLogin, [.exists])
		textFieldLogin.tap()
		textFieldLogin.typeText(login)

		return self
	}

	@discardableResult
	func set(password: String) -> Self {
		assert(textFieldPass, [.exists])
		textFieldPass.tap()
		textFieldPass.typeText(password)

		return self
	}

	@discardableResult
	func login() -> Self {
		assert(buttonLogin, [.exists])
		buttonLogin.tap()

		return self
	}

	@discardableResult
	func closeAlert() -> Self {
		assert(alert, [.exists])
		alert.buttons.firstMatch.tap()

		return self
	}
}
