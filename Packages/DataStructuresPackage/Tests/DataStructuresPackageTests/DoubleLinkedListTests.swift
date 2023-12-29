//
//  File.swift
//  
//
//  Created by Константин Натаров on 27.12.2023.
//

import XCTest
@testable import DataStructuresPackage

final class DoublyLinkedListTests: XCTestCase {

	func test_isEmpty_shouldBeTrue() {
		let sut = DoublyLinkedList<Any>()

		let result = sut.isEmpty

		XCTAssertTrue(result)
	}

	func test_isEmpty_shouldBeFalse() {
		let sut = DoublyLinkedList(value: 1)

		let result = sut.isEmpty

		XCTAssertFalse(result)
	}
}
