//
//  ContentType.swift
//  NetworkLayer
//
//  Created by Kirill Leonov 
//

import Foundation

/// Тип контента.
public enum ContentType {
	/// JSON данные.
	case json
	/// Текстовый файл в формате markdown.
	case markdown
	/// Закодированные данные, переданные в GET запросе.
	case urlencoded
	/// Multi part данные.
	case multipart(boundary: String)
	/// Изображение формата jpeg
	case jpeg
	/// Изображение формата png
	case png
	
	/// Возвращает значение типа контента для передачи в HTTP заголовке.
	public var value: String {
		switch self {
		case .json:
			return "application/json"
		case .markdown:
			return "text/markdown"
		case .urlencoded:
			return "application/x-www-form-urlencoded"
		case .multipart(let boundary):
			return "multipart/form-data; boundary=\(boundary)"
		case .jpeg:
			return "image/jpeg"
		case .png:
			return "image/png"
		}
	}
}
