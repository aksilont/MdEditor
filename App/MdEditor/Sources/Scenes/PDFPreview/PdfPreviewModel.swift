//
//  PdfPreviewModel.swift
//  MdEditor
//
//  Created by Aksilont on 13.03.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

enum PdfPreviewModel {
	enum Response {
		case title(String)
		case data(Data)
	}

	enum ViewModel {
		case title(String)
		case data(Data)
	}
}
