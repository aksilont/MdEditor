//
//  NetworkEndpoints.swift
//  MdEditor
//
//  Created by Aksilont on 24.03.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

enum NetworkEndpoints {
	static let api = URL(string: "https://practice.swiftbook.org/api")! // swiftlint:disable:this force_unwrapping
	
	case login
	case getAllFiles
	case getFile(String)
	case download(String)
	case upload
	case delete(String)
}

extension NetworkEndpoints: CustomStringConvertible {
	var description: String {
		switch self {
		case .login:
			"/auth/login"
		case .getAllFiles:
			"/files"
		case .getFile(let id):
			"/files/\(id)"
		case .download(let id):
			"/files/download/\(id)"
		case .upload:
			"/files/upload"
		case .delete(let id):
			"/files/\(id)"
		}
	}
}
