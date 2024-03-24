//
//  URLComponents+setParameters.swift
//  NetworkLayer
//
//  Created by Kirill Leonov
//

import Foundation

extension URLComponents {
	/// Устанавливает параметры в виде словаря [String: Any] и возвращается новая структура URLComponents.
	/// - Parameter parameters: Параметры для URLComponents.
	/// - Returns: Новая структура URLComponents с установленными параметрами.
	public func setParameters(_ parameters: [String: Any]) -> URLComponents {
		var urlComponents = self
		urlComponents.queryItems = parameters.map { URLQueryItem(name: $0, value: String(describing: $1)) }
		return urlComponents
	}
}
