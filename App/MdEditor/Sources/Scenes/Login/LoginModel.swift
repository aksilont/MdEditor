//
//  LoginModel.swift
//  MdEditor
//
//  Created by Kirill Leonov on 24.11.2023.
//

import Foundation

/// LoginModel является NameSpace для отделения ViewData различных экранов друг отдруга
enum LoginModel {
	struct Request {
		var login: String
		var password: String
	}

	struct Response {
		var result: Result<Void, LoginError>
	}
}
