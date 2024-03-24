//
//  HTTPNetworkServiceError.swift
//  NetworkLayer
//
//  Created by Kirill Leonov 
//

import Foundation

/// Ошибки сетевого слоя.
public enum HTTPNetworkServiceError: Error {
	/// Сетевая ошибка.
	case networkError(Error)
	/// Ответ сервера имеет неожиданный формат.
	case invalidResponse(URLResponse?)
	/// Статус кода ответа, который не входит в диапазон успешных `(200..<300)`.
	case invalidStatusCode(Int, Data?)
	/// Данные отсутствуют.
	case noData
	/// Не удалось декодировать ответ.
	case failedToDecodeResponse(Error)
}
