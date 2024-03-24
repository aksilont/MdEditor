//
//  Parser.swift
//	MarkdownPackage
//
//  Created by Aksilont on 18.02.2024.
//

import Foundation

public final class Parser {
	public init() {}

	public func parse(tokens: [Token]) -> Document {
		var tempTokens = tokens
		var result: [INode] = []

		while !tempTokens.isEmpty {
			var nodes: [INode?] = []
			nodes.append(parseHeader(tokens: &tempTokens))
			nodes.append(parseBlockquote(tokens: &tempTokens))
			nodes.append(parseParagraph(tokens: &tempTokens))
			nodes.append(parseEmptyLine(tokens: &tempTokens))
			nodes.append(parseHorizontalLine(tokens: &tempTokens))
			nodes.append(parseCodeBlock(tokens: &tempTokens))
			nodes.append(parseBulletedList(tokens: &tempTokens))
			nodes.append(parseNumberedList(tokens: &tempTokens))

			/// Очистим массив распарсенных нодов от nil
			let parsedNodes = nodes.compactMap { $0 }

			/// Если массив распарсенных нодов пустой, значит мы не смогли распарсить токен
			/// и его нужно удалить, чтобы перейти к следующему и исключить бесконечный цикл
			if parsedNodes.isEmpty, !tempTokens.isEmpty {
				tempTokens.removeFirst()
			} else {
				result.append(contentsOf: parsedNodes)
			}
		}

		return Document(result)
	}
}

private extension Parser {
	func parseHeader(tokens: inout [Token]) -> HeaderNode? {
		guard let token = tokens.first else { return nil }
		
		if case let .header(level, text) = token {
			tokens.removeFirst()
			var children = parseText(text)
			children.append(LineBreakNode())
			return HeaderNode(level: level, children: children)
		}

		return nil
	}

	func parseBlockquote(tokens: inout [Token]) -> BlockquoteNode? {
		guard let token = tokens.first else { return nil }
		
		if case let .blockQuote(level, text) = token {
			tokens.removeFirst()
			var children = parseText(text)
			children.append(LineBreakNode())
			return BlockquoteNode(level: level, children: children)
		}

		return nil
	}

	func parseParagraph(tokens: inout [Token]) -> ParagraphNode? {
		var textNodes: [INode] = []

		while !tokens.isEmpty {
			guard let token = tokens.first else { return nil }

			if case let .textLine(text) = token {
				tokens.removeFirst()
				textNodes.append(contentsOf: parseText(text))
				textNodes.append(LineBreakNode())
			} else {
				break
			}
		}

		if !textNodes.isEmpty {
			return ParagraphNode(textNodes)
		}

		return nil
	}

	func parseEmptyLine(tokens: inout [Token]) -> EmptyLineNode? {
		guard let token = tokens.first else { return nil }
		
		if case .emptyLine = token {
			tokens.removeFirst()
			return EmptyLineNode()
		}

		return nil
	}

	func parseHorizontalLine(tokens: inout [Token]) -> HorizontalLineNode? {
		guard let token = tokens.first else { return nil }

		if case let .horizontalLine(level: level) = token {
			tokens.removeFirst()
			return HorizontalLineNode(level: level)
		}

		return nil
	}

	func parseCodeBlock(tokens: inout [Token]) -> CodeBlockNode? {
		var inlineCodeItems: [INode] = []
		var startBlock = true
		var levelNode = 0
		var languageNode = ""

		while !tokens.isEmpty {
			guard let token = tokens.first else { return nil }

			if case let .codeBlockMarker(level: level, lang: lang) = token {
				tokens.removeFirst()
				if startBlock {
					levelNode = level
					languageNode = lang
					startBlock = false
				}
			} else if case let .codeLine(text: code) = token {
				tokens.removeFirst()
				inlineCodeItems.append(CodeBlockItem(code: code))
				inlineCodeItems.append(LineBreakNode())
			} else {
				break
			}
		}

		if !inlineCodeItems.isEmpty {
			return CodeBlockNode(level: levelNode, language: languageNode, children: inlineCodeItems)
		}

		return nil
	}

	func parseBulletedList(tokens: inout [Token]) -> BulletedListNode? {
		var listItems: [INode] = []
		var startBlock = true
		var levelNode = 0

		while !tokens.isEmpty {
			guard let token = tokens.first else { return nil }

			if case let .bulletedListItem(level, marker, text) = token {
				tokens.removeFirst()
				let node = BulletedListItem(marker: marker, children: parseText(text))
				listItems.append(node)
				listItems.append(LineBreakNode())
				if startBlock {
					levelNode = level
					startBlock = false
				}
			} else {
				break
			}
		}

		if !listItems.isEmpty {
			return BulletedListNode(level: levelNode, children: listItems)
		}

		return nil
	}

	func parseNumberedList(tokens: inout [Token]) -> NumberedListNode? {
		var listItems: [INode] = []
		var startBlock = true
		var levelNode = 0

		while !tokens.isEmpty {
			guard let token = tokens.first else { return nil }

			if case let .numberedListItem(level, marker, text) = token {
				tokens.removeFirst()
				let node = NumberedListItem(marker: marker, children: parseText(text))
				listItems.append(node)
				if startBlock {
					levelNode = level
					startBlock = false
				}
				listItems.append(LineBreakNode())
			} else {
				break
			}
		}

		if !listItems.isEmpty {
			return NumberedListNode(level: levelNode, children: listItems)
		}

		return nil
	}

	func parseText(_ textOfParts: Text) -> [INode] {
		var textNodes: [INode] = []
		textOfParts.text.forEach { part in
			switch part {
			case .normal(let text):
				textNodes.append(TextNode(text: text))
			case .bold(let text):
				textNodes.append(BoldTextNode(text: text))
			case .italic(let text):
				textNodes.append(ItalicTextNode(text: text))
			case .strike(let text):
				textNodes.append(StrikeTextNode(text: text))
			case .highlighted(let text):
				textNodes.append(HighlightedTextNode(text: text))
			case .boldItalic(let text):
				textNodes.append(BoldItalicTextNode(text: text))
			case .inlineCode(let code):
				textNodes.append(InlineCodeTextNode(code: code))
			case .escapedChar(let char):
				textNodes.append(EscapedCharTextNode(char: char))
			case .link(let header, let url):
				textNodes.append(LinkNode(header: header, url: url))
			case .image(let header, let url):
				textNodes.append(ImageNode(header: header, url: url))
			}
		}
		return textNodes
	}
}
