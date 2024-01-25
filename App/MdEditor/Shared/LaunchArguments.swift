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
	static let appLanguage = ["-AppleLanguages", "(en)"]
}

extension ProcessInfo {
	var isUITesting: Bool {
		return arguments.contains(LaunchArguments.isUItesting)
	}
}
