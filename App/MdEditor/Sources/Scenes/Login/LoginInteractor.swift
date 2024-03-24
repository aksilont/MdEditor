//
//  LoginInteractor.swift
//  MdEditor
//
//  Created by Kirill Leonov on 04.12.2023.
//

import Foundation

protocol ILoginInteractor {
	func login(request: LoginModel.Request)
}

final class LoginInteractor: ILoginInteractor {

	// MARK: - Dependencies

	private var presenter: ILoginPresenter?
	private var worker: ILoginWorker

	// MARK: - Initialization

	init(presenter: ILoginPresenter, worker: ILoginWorker) {
		self.presenter = presenter
		self.worker = worker
	}

	// MARK: - Public methods

	func login(request: LoginModel.Request) {
		worker.login(login: request.login, password: request.password) { [weak self] result in
			DispatchQueue.main.async {
				let responce = LoginModel.Response(result: result)
				self?.presenter?.present(responce: responce)
			}
		}
	}
}
