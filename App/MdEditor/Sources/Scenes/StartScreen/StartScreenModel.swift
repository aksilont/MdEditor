//
//  StartScreenModel.swift
//  MdEditor
//
//  Created by Константин Натаров on 01.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

/// StartScreenModel is namespace for splt viewModels
enum StartScreenModel {
	enum Request {
		case openFileList
		case creaeteNewFile
		case showAbout
		case recentFileSelected(indexPath: IndexPath)
		case deleteRecentFile(indexPath: IndexPath)
	}

	struct Response {
		let docs: [Document]
	}

	enum ViewModel {
		case documents([Document])
		case stub
	}

	struct Document {
		let fileName: String
		let content: String
	}
}
