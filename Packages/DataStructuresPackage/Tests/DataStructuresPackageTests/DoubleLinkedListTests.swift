//
//  File.swift
//  
//
//  Created by Константин Натаров on 27.12.2023.
//

import XCTest
@testable import DataStructuresPackage

final class DoublyLinkedListTests: XCTestCase {
	
	var sut: DoublyLinkedList<Int>!
	
	override func setUp() {
		super.setUp()
		sut = DoublyLinkedList<Int>()
	}
	
	override func tearDown() {
		sut = nil
		super.tearDown()
	}

	/// Тест инициализатора со значением в списке
	func test_initWithValue_shouldBeEqual() {
		let value = 16
		sut = DoublyLinkedList(value: value)
		XCTAssertEqual(sut.value(at: 0), value, "Значения не равны" )
		XCTAssertEqual(sut.headValue, sut.tailValue, "Значение головы не равно значению в хвосте")
	}

	/// Тест инициализатора с пустым список
	func test_initWithoutValue_shouldBeCorrect() {
		XCTAssertTrue(sut.isEmpty, "Список должен быть пустым")
		XCTAssertEqual(sut.count, 0, "Count не равен 0")
	}

	func test_isEmpty_shouldBeFalse() {
		sut.push(1)
		
		XCTAssertFalse(sut.isEmpty, "Список должен содержать значения")
	}
	
	/// Тест добавления в начало списка значения.
	func test_push_shouldBeCorrectCount() {
		sut.push(1)
		
		XCTAssertEqual(sut.count, 1, "Не соответствует количество элементов в списке")
	}
	
	/// Тест добавления в конец списка значения.
	func test_append_shouldBeCorrectCount() {
		sut.append(1)
		
		XCTAssertEqual(sut.count, 1, "Не соответствует количество элементов в списке")
	}
	
	/// Тест добавления в середину списка значения.
	func test_insert_resultShouldBeCorrectValue() {
		sut.append(1)
		sut.append(2)
		
		sut.insert(3, after: 1)
		let result = sut.value(at: 2)
		
		XCTAssertEqual(result, 3, "По индексу не верное значение")
	}

	/// Тест добавления в середину списка значения, индекс которого за пределами списка
	func test_insertWithIndexOutOfRange_resultShouldBeEqual() {
		var previosCount = 0
		sut.append(1)
		sut.append(2)

		previosCount = sut.count
		sut.insert(3, after: 5)

		XCTAssertEqual(previosCount, sut.count, "Ожидалось, что count не изменится")
	}

	func test_insert_countShouldBeCorrect() {
		sut.append(1)
		sut.append(3)
		
		sut.insert(2, after: 0)
		
		XCTAssertEqual(sut.count, 3, "Элемент не добавлен в список")
	}
	
	/// Тест извлечения значения из начала строки.
	func test_pop_resultShouldBeEqual() {
		sut.append(1)
		sut.append(2)
		
		let result = sut.pop()
		
		XCTAssertEqual(result, 1, "Извлечено не верное значение")
	}
	
	func test_pop_countShouldBeCorrect() {
		sut.append(1)
		sut.append(2)
		
		let _ = sut.pop()
		
		XCTAssertEqual(sut.count, 1, "Элемент не удален из списка")
	}

	func test_popWithEmptyList_resultShouldBeNil() {
		let value = sut.pop()

		XCTAssertNil(value, "Ожидалось nil")
	}

	func test_pop_resultShouldBeTrue() {
		sut.append(1)

		let _ = sut.pop()
		
		XCTAssertTrue(sut.isEmpty, "При извлечении в tail осталось значение")
	}

	/// Тест извлечения значения из конца строки.
	func test_removeLast_resultShouldBeEqual() {
		sut.append(1)
		sut.append(2)
		
		let result = sut.removeLast()
		
		XCTAssertEqual(result, 2, "Извлечено не верное значение")
	}
	
	func test_removeLast_countShouldBeCorrect() {
		sut.append(1)
		sut.append(2)
		
		let _ = sut.removeLast()
		
		XCTAssertEqual(sut.count, 1, "Элемент не удален из списка")
	}

	func test_removeLastWithEmptyList() {
		let value = sut.removeLast()

		XCTAssertNil(value, "Извлеченное значение не nil")
	}

	func test_removeLast_resultShouldBeTrue() {
		sut.append(1)

		let _ = sut.removeLast()

		XCTAssertTrue(sut.isEmpty, "При извлечении в Head осталось значение")
	}

	/// Тест извлечения значения из середины строки.
	func test_remove_resultShouldBeEqual() {
		sut.append(1)
		sut.append(2)
		sut.append(3)
		
		let result = sut.remove(after: 0)
		
		XCTAssertEqual(result, 2, "Извлечено не верное значение")
	}
	
	func test_remove_countShouldBeCorrect() {
		sut.append(1)
		sut.append(2)
		
		let _ = sut.remove(after: 0)
		
		XCTAssertEqual(sut.count, 1, "Count ожидался уменьшиться")
	}

	func test_removeWithEmptyList_resultShouldBeNil() {
		let value = sut.remove(after: 2)

		XCTAssertNil(value, "Извлеченное значение ожидалось nil")
	}

	/// Тест получения значения по индексу.
	func test_value_resultShouldBeEqual() {
		sut.append(1)
		sut.append(2)
		sut.append(3)
		sut.append(4)
		sut.append(5)
		sut.append(6)
		let resultFirstHalf = sut.value(at: 0)
		let resultSecondHalf = sut.value(at: 2)
		let anotherResultSecondHalf = sut.value(at: 4)
		
		XCTAssertEqual(resultFirstHalf, 1, "Извлечено неверное значение в первой половине")
		XCTAssertEqual(resultSecondHalf, 3, "Извлечено неверное значение во второй половине")
		XCTAssertEqual(anotherResultSecondHalf, 5, "Извлечено неверное значение в конце списка")
	}
	
	/// Тест проверки текстовой строки  листа
	func test_description_resultresultShouldBeEqual() {
		sut.append(1)
		sut.append(2)
		let expectedResult = "count = 2; list = 1 <-> 2"
		
		let result = sut.description
		
		XCTAssertEqual(result, expectedResult, "Значения не совпадают")
	}
}
