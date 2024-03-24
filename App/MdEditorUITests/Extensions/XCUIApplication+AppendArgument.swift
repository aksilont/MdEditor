//
//  XCUIApplication+AppendArgument.swift
//  MdEditorUITests
//
//  Created by Aksilont on 08.03.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import XCTest

extension XCUIApplication {
	func appendArgument(_ argument: LaunchArguments.Arguments) {
		launchArguments.append(argument.rawValue)
	}
}
