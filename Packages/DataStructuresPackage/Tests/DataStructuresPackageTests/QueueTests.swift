//
//  File.swift
//  
//
//  Created by Константин Натаров on 27.12.2023.
//

import XCTest
@testable import DataStructuresPackage

final class QueueTests: XCTestCase {
	
	var sut: Queue<Int>!
	
	override func setUp() {
		super.setUp()
		sut = Queue<Int>()
	}
	
	override func tearDown() {
		sut = nil
		super.tearDown()
	}
	
	/// Тест свойства определяющего, пуста ли очередь.
	func test_isEmpty_shouldBeTrue() {
		XCTAssertTrue(sut.isEmpty, "Очередь содержит значения")
	}
	
	func test_isEmpty_shouldBeFalse() {
		sut.enqueue(1)
		
		XCTAssertFalse(sut.isEmpty, "Очередь не содержит значения")
	}
	
	/// Тест свойства определяющего, количество элементов.
	func test_count_shouldBeCorrect() {
		sut.enqueue(1)
		
		XCTAssertEqual(sut.count, 1, "Некорректное значение количества элементов")
	}
	
	/// Тест свойства возвращающего значение первого элемента.
	func test_peek_resultShouldBeEqual() {
		sut.enqueue(1)
		sut.enqueue(2)
		
		let result = sut.peek
		
		XCTAssertEqual(result, 1, "Некорректное значение")
	}
	
	/// Тест метода, который удаляет и возвращает первый элемент.
	func test_dequeue_resultShouldBeEqual() {
		sut.enqueue(1)
		sut.enqueue(2)
		
		let result = sut.dequeue()
		
		XCTAssertEqual(result, 1, "Некорректное значение")
	}
}

