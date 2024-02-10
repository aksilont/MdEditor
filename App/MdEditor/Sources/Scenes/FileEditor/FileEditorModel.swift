//
//  AboutModel.swift
//  MdEditor
//
//  Created by Aleksey Efimov on 03.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

enum FileEditorModel {

	struct Response {
		let title: String
		let fileData: String
	}
	
	struct ViewModel {
		let title: String
		let fileData: String
	}
}
