//
//  Parameters.swift
//  NetworkLayer
//
//  Created by Kirill Leonov 
//

import Foundation

/// Параметры запроса.
public enum Parameters {
	/// Параметры отсутствуют.
	case none
	/// Параметры, передающиеся в URL, используется в GET запросах. Содержит параметры в виде словаря.
	case url([String: Any])
	/// JSON запрос. Содержит в себе JSON в виде словаря.
	case json([String: Any])
	/// Тип содержимого, чаще всего использующийся для отправки HTML-форм с бинарными данными методом POST.
	/// Содержить параметры в виде словаря.
	case formData([String: Any])
	/// Любые бинарные данные для отправки методом POST. Содержит в себе данные и тип данных.
	case data(Data, ContentType)
	
	public var contentType: ContentType? {
		switch self {
		case .none, .url: // Так как параметры отсутствуют, то и тип их тоже отсутствует.
			return nil
		case let .data(_, type):
			return type
		case .formData:
			return .urlencoded
		case .json:
			return .json
		}
	}
}
