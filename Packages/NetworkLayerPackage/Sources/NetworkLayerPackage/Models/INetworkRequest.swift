//
//  INetworkRequest.swift
//  NetworkLayer
//
//  Created by Kirill Leonov 
//

import Foundation

/// Протокол для создания сетевых запросов.
public protocol INetworkRequest {
	/// Путь запроса.
	var path: String { get }
	/// HTTP Метод, указывающий тип запроса.
	var method: HTTPMethod { get }
	/// HTTP заголовок.
	var header: HTTPHeader? { get }
	/// Параметры запроса.
	var parameters: Parameters { get }
}

/// Расширение с пустым HTTP заголовком, для удобства составления запросов без заголовка.
extension INetworkRequest {
	/// Значение HTTPHeaders по умолчанию
	public var header: HTTPHeader? { nil }
}
