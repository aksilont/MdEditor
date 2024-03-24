//
//  URLRequestBuilder.swift
//  NetworkLayer
//
//  Created by Kirill Leonov 
//

import Foundation

/// Сервис, собирающий запрос из NetworkRequest.
protocol IURLRequestBuilder {
	/// Сервис, собирающий запрос из NetworkRequest.
	func build(forRequest request: INetworkRequest, token: Token?) -> URLRequest
}

/// Сервис, собирающий запрос из NetworkRequest.
struct URLRequestBuilder: IURLRequestBuilder {
	/// Базовый URL сервиса для которого будут создаваться запросы.
	var baseUrl: URL
	
	
	/// Метод собирающий URLRequest из NetworkRequest.
	/// - Parameters:
	///   - request: Сетевой запрос.
	///   - token: Авторизационный токен.
	/// - Returns: Сформированный URLRequest.
	func build(forRequest request: INetworkRequest, token: Token?) -> URLRequest {
		let url = baseUrl.appendingPathComponent(request.path)
		
		var urlRequest = URLRequest(url: url)
		
		urlRequest.httpMethod = request.method.rawValue
		urlRequest.allHTTPHeaderFields = request.header
		
		urlRequest.add(parameters: request.parameters)
		
		if let contentType = request.parameters.contentType {
			urlRequest.add(header: .contentType(contentType))
		}
		
		if let token = token {
			urlRequest.add(header: .authorization(token))
		}
		
		return urlRequest
	}
}

extension URLRequest {
	mutating func add(header: HeaderField) {
		setValue(header.value, forHTTPHeaderField: header.key)
	}
	
	/// Метод добавляющий параметры
	/// - Parameters:
	///  - parameters: параметры типа RequestParameters
	mutating func add(parameters: Parameters) {
		switch parameters {
		case .none:
			break
		case .url(let dictionary):
			guard let url = url, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { break }
			components = components.setParameters(dictionary)
			guard let newUrl = components.url else { break }
			self.url = newUrl
			
		case .json(let dictionary):
			httpBody = try? JSONSerialization.data(withJSONObject: dictionary)
		case .formData(let dictionary):
			httpBody = URLComponents().setParameters(dictionary).query?.data(using: .utf8)
		case .data(let data, _):
			httpBody = data
		}
	}
}
