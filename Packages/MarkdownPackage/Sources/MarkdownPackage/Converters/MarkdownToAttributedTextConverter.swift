//
//  MarkdownToAttributedTextConverter.swift
//
//
//  Created by Aleksey Efimov on 01.03.2024.
//

import Foundation

public final class MarkdownToAttributedTextConverter: IMarkdownConverter {
	private let markdownToDocument = MarkdownToDocument()
	
	public init() { }
	
	public func convert(markdownText: String) -> NSMutableAttributedString {
		let document = markdownToDocument.convert(markdownText: markdownText)
		let result = convert(document: document)
		return result
	}
	
	public func convert(markdownText: String, completion: @escaping (NSMutableAttributedString) -> Void) {
		DispatchQueue.global().async { [weak self] in
			guard let self else { return }
			let document = self.markdownToDocument.convert(markdownText: markdownText)
			let result = self.convert(document: document)
			completion(result)
		}
	}

	private func convert(document: Document) -> NSMutableAttributedString {
		let visitor = AttributedTextVisitor()
		
		let result = document.accept(visitor: visitor)
		return result.joined()
	}
}
