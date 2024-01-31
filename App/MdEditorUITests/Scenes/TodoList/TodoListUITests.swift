//
//  TodoListUITests.swift
//  MdEditorUITests
//
//  Created by Aksilont on 20.01.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import XCTest

final class TodoListUITests: XCTestCase {
	func test_todoList_sectionsTitle_shouldeBeHaveCorrectTitle() {
		let sut = makeSUT()
		sut
			.isTodoListScreen()
			.checkSectionsTitle()
	}

	func test_todoList_cellsInfo_shouldBeHaveCorrectInfo() {
		let sut = makeSUT()
		sut
			.isTodoListScreen()
			.checkCellsInfo()
	}

	func test_todoList_tapOnCell_shouldBeChangeStatusComplitionTask() {
		let sut = makeSUT()
		sut
			.isTodoListScreen()
			.tapOnCell()
	}
}

// MARK: - Private Extension
private extension TodoListUITests {
	/// Создать и подготовить объект-приложение для тестирования
	func makeSUT() -> TodoListScreenObject {
		let app = XCUIApplication()
		let screen = TodoListScreenObject(app: app)
		app.launchArguments.append(LaunchArguments.isUItesting)
		app.launchArguments.append(LaunchArguments.skipLogin)
		app.launchArguments.append(contentsOf: LaunchArguments.appLanguage)
		app.launch()

		return screen
	}
}
