//
//  HtmlVisitor.swift
//  MdEditor
//
//  Created by Aleksey Efimov on 22.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

final class HtmlVisitor: IVisitor {
	func visit(_ node: HighlightedTextNode) -> String {
		String()
	}
	
	func visit(_ node: StrikeTextNode) -> String {
		String()
	}
	
	typealias Result = String
	
	func visit(_ node: MarkdownPackage.Document) -> [String] {
		[String()]
	}
	
	func visit(_ node: MarkdownPackage.HeaderNode) -> String {
		String()
	}
	
	func visit(_ node: MarkdownPackage.BlockquoteNode) -> String {
		String()
	}
	
	func visit(_ node: MarkdownPackage.ParagraphNode) -> String {
		String()
	}
	
	func visit(_ node: MarkdownPackage.TextNode) -> String {
		String()
	}
	
	func visit(_ node: MarkdownPackage.BoldTextNode) -> String {
		String()
	}
	
	func visit(_ node: MarkdownPackage.ItalicTextNode) -> String {
		String()
	}
	
	func visit(_ node: MarkdownPackage.BoldItalicTextNode) -> String {
		String()
	}
	
	func visit(_ node: MarkdownPackage.InlineCodeTextNode) -> String {
		String()
	}
	
	func visit(_ node: MarkdownPackage.EscapedCharTextNode) -> String {
		String()
	}
	
	func visit(_ node: MarkdownPackage.LinkNode) -> String {
		String()
	}
	
	func visit(_ node: MarkdownPackage.ImageNode) -> String {
		String()
	}
	
	func visit(_ node: MarkdownPackage.LineBreakNode) -> String {
		String()
	}
	
	func visit(_ node: MarkdownPackage.HorizontalLineNode) -> String {
		String()
	}
	
	func visit(_ node: MarkdownPackage.CodeBlockNode) -> String {
		String()
	}
	
	func visit(_ node: MarkdownPackage.BulletedListNode) -> String {
		String()
	}
	
	func visit(_ node: MarkdownPackage.BulletedListItem) -> String {
		String()
	}
	
	func visit(_ node: MarkdownPackage.NumberedListNode) -> String {
		String()
	}
	
	func visit(_ node: MarkdownPackage.NumberedListItem) -> String {
		String()
	}
}
