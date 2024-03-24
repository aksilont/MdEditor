//
//  StringOrInt.swift
//  NetworkLayer
//
//  Created by Kirill Leonov
//

import Foundation

public enum StringOrInt: Codable {
	case string(String)
	case int(Int)

	public func getValue() -> String {
		switch self {
		case .string(let string):
			return string
		case .int(let int):
			return "\(int)"
		}
	}

	public init(from decoder: Decoder) throws {
		if let value = try? decoder.singleValueContainer().decode(String.self) {
			self = .string(value)
			return
		}

		if let value = try? decoder.singleValueContainer().decode(Int.self) {
			self = .int(value)
			return
		}

		throw Error.decodingError
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		switch self {
		case .string(let value):
			try container.encode(value)
		case .int(let value):
			try container.encode(value)
		}
	}

	public enum Error: Swift.Error {
		case decodingError
	}
}
