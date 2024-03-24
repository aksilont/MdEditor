//
//  ResponseStatus.swift
//  NetworkLayer
//
//  Created by Kirill Leonov 
//

import Foundation

/// Коды ответа сервера на запрос.
public enum ResponseStatus {
	/// Информационный статус.
	case information(Int)
	/// Статус успешного выполнения запросса.
	case success(Int)
	/// Перенаправление.
	case redirect(Int)
	/// Ошибка клиента.
	case clientError(Int)
	/// Ошибка сервера.
	case serverError(Int)
	
	init?(rawValue: Int) {
		switch rawValue {
		case ResponseCode.informationalCodes:
			self = .information(rawValue)
		case ResponseCode.successCodes:
			self = .success(rawValue)
		case ResponseCode.redirectCodes:
			self = .redirect(rawValue)
		case ResponseCode.clientErrorCodes:
			self = .clientError(rawValue)
		case ResponseCode.serverErrorCodes:
			self = .serverError(rawValue)
		default:
			return nil
		}
	}
	
	/// Возвращает true, если статус был success.
	var isSuccess: Bool {
		switch self {
		case .success:
			return true
		default:
			return false
		}
	}
}

