//
//  UserDefaults+Keys.swift
//  MdEditor
//
//  Created by Aksilont on 22.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

extension UserDefaults {
	enum Keys: String, CaseIterable {
		case recentFilesKey
	}

	func reset() {
		Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
	}
}
