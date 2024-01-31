//
//  LaunchArguments.swift
//  MdEditor
//
//  Created by Aksilont on 22.01.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

enum LaunchArguments {
	static let isUItesting = "-isUITesting"
	static let skipLogin = "-skipLogin"
	static let appLanguage = ["-AppleLanguages", "(en)"]
}

extension CommandLine {
	static var isUITesting: Bool {
		return CommandLine.arguments.contains(LaunchArguments.isUItesting)
	}
	static var skipLogin: Bool {
		return CommandLine.arguments.contains(LaunchArguments.skipLogin)
	}
}
