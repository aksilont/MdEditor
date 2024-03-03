//
//  StartScreenObject.swift
//  MdEditor
//
//  Created by Aleksey Efimov on 12.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import XCTest

final class StartScreenObject: BaseScreenObject {
	
	// MARK: - Private properties
	private lazy var collectionView = app.collectionViews[AccessibilityIdentifier.StartScreen.collectionView.description]
	private lazy var buttonNew = app.buttons[AccessibilityIdentifier.StartScreen.buttonNew.description]
	private lazy var buttonOpen = app.buttons[AccessibilityIdentifier.StartScreen.buttonOpen.description]
	private lazy var buttonAbout = app.buttons[AccessibilityIdentifier.StartScreen.buttonAbout.description]

	// MARK: - ScreenObject Methods
	@discardableResult
	func isStartScreen() -> Self {
		assert(buttonNew, [.exists])
		assert(buttonOpen, [.exists])
		assert(buttonAbout, [.exists])
		
		return self
	}
}
