//
//  LaunchArguments.swift
//  MdEditor
//
//  Created by Aksilont on 22.01.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

struct LaunchArguments {
	enum Arguments: String, CaseIterable {
		case isUITesting = "-isUITesting"
		case runTodoListFlow = "-runTodoListFlow"
		case runEditorFlow = "-runEditorFlow"
	}

	// Создание списка параметров происходит один раз при обращении к структуре LaunchArguments
	private static let parameters: [LaunchArguments.Arguments: Bool] = {
		Arguments.allCases.reduce(into: [:]) { result, arg in
			result[arg] = CommandLine.arguments.contains(arg.rawValue)
		}
	}()

	static subscript(argument: LaunchArguments.Arguments) -> Bool {
		parameters[argument] ?? false
	}
}
