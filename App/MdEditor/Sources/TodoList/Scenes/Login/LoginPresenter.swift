//
//  LoginPresenter.swift
//  MdEditor
//
//  Created by Kirill Leonov on 04.12.2023.
//

import Foundation

protocol ILoginPresenter {

	/// Отображение экрана со авторизации.
	/// - Parameter response: Подготовленные к отображению данные.
	func present(responce: LoginModel.Response)
}

typealias LoginResultClosure = (Result<Void, LoginError>) -> Void

final class LoginPresenter: ILoginPresenter {

	// MARK: - Dependencies

	private weak var viewController: ILoginViewController?
	private var loginResultClosure: LoginResultClosure?

	// MARK: - Initialization

	init(viewController: ILoginViewController?, loginResultClosure: LoginResultClosure?) {
		self.viewController = viewController
		self.loginResultClosure = loginResultClosure
	}

	// MARK: - Public methods

	/// Отображение экрана со авторизации.
	/// - Parameter response: Подготовленные к отображению данные.
	func present(responce: LoginModel.Response) {
		loginResultClosure?(responce.result)
	}
}

extension LoginError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .wrongPassword:
			return L10n.LoginError.wrongPassword
		case .wrongLogin:
			return L10n.LoginError.wrongLogin
		case .emptyFields:
			return L10n.LoginError.emptyFields
		case .errorAuth:
			return L10n.LoginError.errorAuth
		}
	}
}
