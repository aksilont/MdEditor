//
//  MarkdownToAttributedTextConverter.swift
//
//
//  Created by Aleksey Efimov on 01.03.2024.
//

import Foundation

public final class MarkdownToAttributedTextConverter {
	private let markdownToDocument = MarkdownToDocument()
	
	public init() { }
	
	public func convert(markdownText: String) -> NSMutableAttributedString {
		let document = markdownToDocument.convert(markdownText: markdownText)
		
		return convert(document: document)
	}
	
	func convert(document: Document) -> NSMutableAttributedString {
		let visitor = AttributedTextVisitor()
		
		let result = document.accept(visitor: visitor)
		return result.joined()
	}
}
