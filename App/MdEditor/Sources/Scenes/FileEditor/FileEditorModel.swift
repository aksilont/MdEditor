//
//  AboutModel.swift
//  MdEditor
//
//  Created by Aleksey Efimov on 03.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

enum FileEditorModel {
	enum Request {
		case exportToPDF
	}

	struct Response {
		let title: String
		let fileData: NSMutableAttributedString
	}
	
	struct ViewModel {
		let title: String
		let fileData: NSMutableAttributedString
	}
}
