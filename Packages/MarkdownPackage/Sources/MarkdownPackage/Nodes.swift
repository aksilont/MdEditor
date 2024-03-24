//
//  Nodes.swift
//	MarkdownPackage
//
//  Created by Aksilont on 18.02.2024.
//

import Foundation

public protocol INode {
	var children: [INode] { get }
}

public class BaseNode: INode {
	private(set) public var children: [INode]

	public init(_ children: [INode] = []) {
		self.children = children
	}
}

// MARK: - Main Root Node - Document
public final class Document: BaseNode {
}

extension Document {
	func accept<T: IVisitor>(visitor: T) -> [T.Result] {
		visitor.visit(self)
	}
}

// MARK: - Header
public final class HeaderNode: BaseNode {
	public let level: Int

	public init(level: Int, children: [INode] = []) {
		self.level = level
		super.init(children)
	}
}

// MARK: - Block Quote
public final class BlockquoteNode: BaseNode {
	public let level: Int

	public init(level: Int, children: [INode] = []) {
		self.level = level
		super.init(children)
	}
}

// MARK: - Paragraph
public final class ParagraphNode: BaseNode {
}

public final class TextNode: BaseNode {
	public let text: String

	public init(text: String) {
		self.text = text
	}
}

public final class BoldTextNode: BaseNode {
	public let text: String

	public init(text: String) {
		self.text = text
	}
}

public final class ItalicTextNode: BaseNode {
	public let text: String

	public init(text: String) {
		self.text = text
	}
}

public final class StrikeTextNode: BaseNode {
	public let text: String
	
	public init(text: String) {
		self.text = text
	}
}

public final class HighlightedTextNode: BaseNode {
	public let text: String
	
	public init(text: String) {
		self.text = text
	}
}

public final class BoldItalicTextNode: BaseNode {
	public let text: String

	public init(text: String) {
		self.text = text
	}
}

public final class InlineCodeTextNode: BaseNode {
	public let code: String

	public init(code: String) {
		self.code = code
	}
}

public final class EscapedCharTextNode: BaseNode {
	public let char: String

	public init(char: String) {
		self.char = char
	}
}

public final class LinkNode: BaseNode {
	public let header: String
	public let url: String

	public init(header: String, url: String) {
		self.header = header
		self.url = url
	}
}

public final class ImageNode: BaseNode {
	public let header: String
	public let size: String
	public let url: String

	public init(header: String, size: String = "", url: String) {
		self.header = header
		self.size = size
		self.url = url
	}
}

// MARK: - Line Break
public final class LineBreakNode: BaseNode {
}

// MARK: - Empty Line
public final class EmptyLineNode: BaseNode {
}

// MARK: - Horizontal Line
public final class HorizontalLineNode: BaseNode {
	public let level: Int
	
	public init(level: Int) {
		self.level = level
	}
}

// MARK: - Code Block
public final class CodeBlockNode: BaseNode {
	public let level: Int
	public let language: String

	public init(level: Int, language: String, children: [INode] = []) {
		self.level = level
		self.language = language
		super.init(children)
	}
}

public final class CodeBlockItem: BaseNode {
	public let code: String

	public init(code: String) {
		self.code = code
	}
}

// MARK: - Bulleted List
public final class BulletedListNode: BaseNode {
	public let level: Int

	public init(level: Int, children: [INode] = []) {
		self.level = level
		super.init(children)
	}
}

public final class BulletedListItem: BaseNode {
	public let marker: String

	public init(marker: String, children: [INode]) {
		self.marker = marker
		super.init(children)
	}
}

// MARK: - Numbered List
public final class NumberedListNode: BaseNode {
	public let level: Int

	public init(level: Int, children: [INode] = []) {
		self.level = level
		super.init(children)
	}
}

public final class NumberedListItem: BaseNode {
	public let marker: String

	public init(marker: String, children: [INode]) {
		self.marker = marker
		super.init(children)
	}
}
