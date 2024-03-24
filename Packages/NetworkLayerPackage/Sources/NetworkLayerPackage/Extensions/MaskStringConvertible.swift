//
//  MaskStringConvertible.swift
//  MdEditor
//
//  Created by Kirill Leonov 
//

import Foundation

public protocol MaskStringConvertible: CustomStringConvertible, CustomDebugStringConvertible { }

public extension MaskStringConvertible {
	var description: String {
		"***********"
	}
	
	var debugDescription: String {
		"***********"
	}
}
