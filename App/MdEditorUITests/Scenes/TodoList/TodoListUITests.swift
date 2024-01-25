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
		let app = XCUIApplication()
		let loginScreen = LoginScreenObject(app: app)
		let todoScreen = TodoListScreenObject(app: app)
		app.launchArguments.append(LaunchArguments.isUItesting)
		app.launchArguments.append(contentsOf: LaunchArguments.appLanguage)
		app.launch()

		loginScreen
			.isLoginScreen()
			.set(login: "Admin")
			.set(password: "pa$$32!")
			.login()

		todoScreen
			.isTodoListScreen()
			.checkSectionsTitle()
	}

	func test_todoList_cellsInfo_shouldBeHaveCorrectInfo() {
		let app = XCUIApplication()
		let loginScreen = LoginScreenObject(app: app)
		let todoScreen = TodoListScreenObject(app: app)
		app.launchArguments.append(LaunchArguments.isUItesting)
		app.launchArguments.append(contentsOf: LaunchArguments.appLanguage)
		app.launch()

		loginScreen
			.isLoginScreen()
			.set(login: "Admin")
			.set(password: "pa$$32!")
			.login()

		todoScreen
			.isTodoListScreen()
			.checkCellsInfo()
	}

	func test_todoList_tapOnCell_shouldBeChangeStatusComplitionTask() {
		let app = XCUIApplication()
		let loginScreen = LoginScreenObject(app: app)
		let todoScreen = TodoListScreenObject(app: app)
		app.launchArguments.append(LaunchArguments.isUItesting)
		app.launchArguments.append(contentsOf: LaunchArguments.appLanguage)
		app.launch()

		loginScreen
			.isLoginScreen()
			.set(login: "Admin")
			.set(password: "pa$$32!")
			.login()

		todoScreen
			.isTodoListScreen()
			.tapOnCell()
	}
}
