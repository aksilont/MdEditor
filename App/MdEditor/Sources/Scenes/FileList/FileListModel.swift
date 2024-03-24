//
//  FileListModel.swift
//  MdEditor
//
//  Created by Aksilont on 31.01.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

enum FileListModel {
	enum Request {
		case fileSelected(indexPath: IndexPath)
		case goHome
	}

	struct Response {
		let currentFile: FileSystemEntity?
		let data: [FileSystemEntity]
	}
	
	struct ViewModel {
		let title: String
		let data: [FileViewModel]

		struct FileViewModel {
			let name: String
			let isDir: Bool
			let description: String
		}
	}
}
