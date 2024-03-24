//
//  NullCodable.swift
//  NetworkLayer
//
//  Created by Aksilont
//

import Foundation

@propertyWrapper
public struct NullCodable<T>: Codable where T: Codable {
	public var wrappedValue: T?

	enum CodingKeys: CodingKey {
		case wrappedValue
	}

	// MARK: - Initialization
	public init(wrappedValue: T?) {
		self.wrappedValue = wrappedValue
	}

	// MARK: - Codable
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		wrappedValue = try container.decodeIfPresent(T.self, forKey: CodingKeys.wrappedValue)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		switch wrappedValue {
		case .none:
			try container.encodeNil()
		case .some(let value):
			try container.encode(value)
		}
	}
}
