//
//  String+Attributed.swift
//  MdEditor
//
//  Created by Aleksey Efimov on 26.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

extension String {
	var attributed: NSMutableAttributedString {
		NSMutableAttributedString(string: self)
	}
	
	static var lineBreak: NSMutableAttributedString {
		NSMutableAttributedString(string: "\n")
	}
	
	static var tab: NSMutableAttributedString {
		NSMutableAttributedString(string: "\t")
	}
}
