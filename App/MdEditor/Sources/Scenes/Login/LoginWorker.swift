//
//  LoginWorker.swift
//  MdEditor
//
//  Created by Kirill Leonov on 04.12.2023.
//

import Foundation
import NetworkLayerPackage
import OSLog

protocol ILoginWorker {
	/// Авторизация пользователя.
	/// - Parameters:
	///   - login: Логин пользователя.
	///   - password: Пароль пользователя.
	///   - completion: Результат прохождения авторизации.
	func login(login: String, password: String, completion: @escaping (Result<Void, LoginError>) -> Void)
}

enum LoginError: Error {
	case wrongPassword
	case wrongLogin
	case errorAuth
	case emptyFields
}

struct NetworkRequestLogin: INetworkRequest {
	let path = NetworkEndpoints.login.description
	let method = HTTPMethod.post
	let header = [
		HeaderField.contentType(.json).key: ContentType.json.value
	   ]
	let parameters: Parameters

	init (login: String, password: String) {
		parameters = Parameters.json([
			"login": login,
			"password": password
		])
	}
}

struct NetworkResponseLogin: Codable {
	let token: String
	enum CodingKeys: String, CodingKey {
		case token = "access_token"
	}
}

final class LoginWorker: ILoginWorker {
	// MARK: - Private properties
	private let logger = Logger(subsystem: "MdEditor.Logger", category: "LoginWorker")
	private let networkService = NetworkService(session: URLSession.shared, baseUrl: NetworkEndpoints.api)

	// MARK: - Public methods
	func login(login: String, password: String, completion: @escaping (Result<Void, LoginError>) -> Void) {
		guard !login.isEmpty, !password.isEmpty else {
			completion(.failure(.emptyFields))
			return
		}

		let networkRequest = NetworkRequestLogin(login: login, password: password)
		networkService.perform(networkRequest, token: nil) { [weak self] result in
			if case let .success(response) = result as Result<NetworkResponseLogin, HTTPNetworkServiceError> {
				KeychainService().set(response.token)
				self?.logger.info("Login success")
				completion(.success(()))
			} else if case let .failure(error) = result {
				self?.logger.error("Network response error - \(error)")
				completion(.failure(.errorAuth))
			}
		}
	}
}

class StubLoginWorker: ILoginWorker {
	// MARK: - Public methods
	func login(login: String, password: String, completion: @escaping (Result<Void, LoginError>) -> Void) {
		guard !login.isEmpty, !password.isEmpty else {
			completion(.failure(.emptyFields))
			return
		}

		switch (login == "Login", password == "Password") {
		case (true, true):
			completion(.success(()))
		case (false, true):
			completion(.failure(.wrongLogin))
		case (true, false):
			completion(.failure(.wrongPassword))
		case (false, false):
			completion(.failure(.errorAuth))
		}
	}
}
