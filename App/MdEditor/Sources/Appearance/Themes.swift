//
//  Themes.swift
//  MdEditor
//
//  Created by Aksilont on 21.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

enum Theme {
	static let mainColor = Colors.purple
	static let accentColor = Colors.purple
	static let tintColor = Colors.orange
	static let textColor = Colors.black
	static let secondaryTextColor = Colors.purple
	static let importantColor = Colors.red
	static let tintColorCell = Colors.green
	static let backgroundColor = Colors.white
	static let borderColor = Colors.purple
	static let previewColor = UIColor.systemGray6.withAlphaComponent(0.2)
	static let stubColor = UIColor.systemGray3

	enum ImageIcon {
		static let aboutUs = UIImage(systemName: "info.bubble.fill")
		static let unknown = UIImage(systemName: "questionmark.app.dashed")
		static let directory = UIImage(systemName: "folder.fill")
		static let file = UIImage(systemName: "doc.text.fill")
		static let deleteFile = UIImage(systemName: "minus.circle.fill")
		static let newFile = UIImage(systemName: "plus")
	}
}
