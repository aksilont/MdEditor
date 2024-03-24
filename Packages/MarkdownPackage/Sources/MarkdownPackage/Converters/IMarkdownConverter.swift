//
//  IMarkdownConverter.swift
//
//
//  Created by Aksilont on 13.03.2024.
//

import Foundation

public protocol IMarkdownConverter {
	associatedtype T
	func convert(markdownText: String, completion: @escaping (T) -> Void)
}
