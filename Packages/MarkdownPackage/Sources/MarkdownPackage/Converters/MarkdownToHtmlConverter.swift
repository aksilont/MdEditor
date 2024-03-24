//
//  MarkdownToHtmlConverter.swift
//
//
//  Created by Aleksey Efimov on 01.03.2024.
//

import Foundation

public final class MarkdownToHtmlConverter: IMarkdownConverter {
	private let markdownToDocument = MarkdownToDocument()
	
	public init() { }

	public func convert(markdownText: String, completion: @escaping (String) -> Void) {
		DispatchQueue.global().async { [weak self] in
			guard let self else { return }
			let document = self.markdownToDocument.convert(markdownText: markdownText)

			let visitor = HtmlVisitor()
			let html = document.accept(visitor: visitor)

			completion(self.makeHtml(html.joined()))
		}
	}

	func makeHtml(_ text: String) -> String {
		return "<!DOCTYPE html><html><head><style> body {font-size:300%;}</style></head><boby>\(text)</boby></html>"
	}
}
