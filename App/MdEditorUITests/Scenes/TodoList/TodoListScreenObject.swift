//
//  TodoListScreenObject.swift
//  MdEditorUITests
//
//  Created by Aksilont on 20.01.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import XCTest

final class TodoListScreenObject: BaseScreenObject {
	// MARK: - Private properties
	private lazy var tableView = app.tables[AccessibilityIdentifier.TodoList.tableView.description]
	private let titleTaskCorrect = "!!! Do homework"

	// MARK: - ScreenObject Methods
	@discardableResult
	func isTodoListScreen() -> Self {
		assert(tableView, [.exists])

		return self
	}

	@discardableResult
	func checkSectionsTitle() -> Self {
		let completedSection = L10n.TodoList.Section.completed
		let uncompletedSection = L10n.TodoList.Section.uncompleted

		let section0 = tableView.otherElements[AccessibilityIdentifier.TodoList.section(index: 0).description]
		XCTAssertEqual(section0.label, uncompletedSection, "Title section 0 should be equal '\(uncompletedSection)'")

		let section1 = tableView.otherElements[AccessibilityIdentifier.TodoList.section(index: 1).description]
		XCTAssertEqual(section1.label, completedSection, "Title section 1 should be equal '\(completedSection)'")

		return self
	}

	@discardableResult
	func checkCellsInfo() -> Self {
		let cell = tableView.cells[AccessibilityIdentifier.TodoList.cell(section: 0, row: 0).description]
		assert(cell, [.exists])

		let titleTask = cell.staticTexts.element(boundBy: 0).label
		XCTAssertEqual(titleTask, titleTaskCorrect, "Title task should be equal '\(titleTaskCorrect)'")

		let deadlineTask = cell.staticTexts.element(boundBy: 1).label
		let isDeadlineTaskContain = deadlineTask.contains(L10n.TodoList.deadline)
		XCTAssertEqual(isDeadlineTaskContain, true, "'\(deadlineTask)' should contain '\(L10n.TodoList.deadline)'")

		return self
	}

	@discardableResult
	func tapOnCell() -> Self {
		var cell = tableView.cells[AccessibilityIdentifier.TodoList.cell(section: 0, row: 0).description]
		var titleTask = cell.staticTexts[titleTaskCorrect]
		assert(cell, [.exists])
		assert(titleTask, [.exists])
		assert(cell, [.isNotSelected])
		cell.tap()

		cell = tableView.cells[AccessibilityIdentifier.TodoList.cell(section: 1, row: 0).description]
		titleTask = cell.staticTexts[titleTaskCorrect]
		assert(cell, [.exists])
		assert(titleTask, [.exists])
		assert(cell, [.isSelected])
		cell.tap()

		return self
	}
}
