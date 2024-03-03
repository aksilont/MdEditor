//
//  MarkdownToDocument.swift
//
//
//  Created by Aleksey Efimov on 01.03.2024.
//

import Foundation

public final class MarkdownToDocument {
	private let lexer = Lexer()
	private let parser = Parser()
	
	public init() { }
	
	public func convert(markdownText: String) -> Document {
		let tokens = lexer.tokenize(markdownText)
		let document = parser.parse(tokens: tokens)
		
		return document
	}
}
