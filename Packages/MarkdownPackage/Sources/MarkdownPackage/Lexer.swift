//
//  Lexer.swift
//	MarkdownPackage
//
//  Created by Aksilont on 15.02.2024.
//

import Foundation

protocol ILexer {
	func tokenize(_ input: String) -> [Token]
}

public final class Lexer: ILexer {
	public init() { }
	
	public func tokenize(_ input: String) -> [Token] {
		
		let lines = input.components(separatedBy: .newlines)
		var tokens: [Token?] = []
		var inCodeBlock = false
		
		for line in lines {
			if let codeBlockToken = parseCodeBlockMarker(rawText: line) {
				tokens.append(codeBlockToken)
				inCodeBlock.toggle()
				continue
			}

			if !inCodeBlock {
				if let bulletedListItem = parseBulletedListItem(rawText: line) {
					tokens.append(bulletedListItem)
					continue
				}

				if let numberedListItem = parseNumberedListItem(rawText: line) {
					tokens.append(numberedListItem)
					continue
				}

				if let horizontalLine = parseHorizontalLine(rawText: line) {
					tokens.append(horizontalLine)
					continue
				}

				tokens.append(parseEmptyLine(rawText: line))
				tokens.append(parseHeader(rawText: line))
				tokens.append(parseBlockquote(rawText: line))
				tokens.append(parseTextLine(rawText: line))
			} else {
				tokens.append(.codeLine(text: line))
			}
		}

		return tokens.compactMap { $0 }
	}
}

private extension Lexer {
	func parseEmptyLine(rawText: String) -> Token? {
		guard rawText.isEmpty else { return nil }
		return .emptyLine
	}

	func parseHorizontalLine(rawText: String) -> Token? {
		let pattern = #"^[\_\-\=]{3,}"#
		if rawText.firstMatch(pattern: pattern) != nil {
			let level = rawText.filter { $0 == "_" }.count
			return .horizontalLine(level: level)
		}
		return nil
	}

	func parseHeader(rawText: String) -> Token? {
		let pattern = #"^(?<level>#{1,6})\s+(?<text>.+)"#
		if let match = rawText.firstMatch(pattern: pattern) {
			let rangeLevel = match.range(withName: "level")
			let rangeText = match.range(withName: "text")
			let level = rawText.substring(with: rangeLevel).count
			let text = parseString(rawText.substring(with: rangeText))
			return .header(level: level, text: text)
		}
		return nil
	}
	
	func parseTextLine(rawText: String) -> Token? {
		let pattern = #"^(?<text>[^#>].*)"#
		if let match = rawText.firstMatch(pattern: pattern) {
			let rangeText = match.range(withName: "text")
			let text = parseString(rawText.substring(with: rangeText))
			return .textLine(text: text)
		}
		return nil
	}

	func parseBlockquote(rawText: String) -> Token? {
		let pattern = #"^(?<level>>{1,6})\s*(?<text>.+)"#
		if let match = rawText.firstMatch(pattern: pattern) {
			let rangeLevel = match.range(withName: "level")
			let rangeText = match.range(withName: "text")
			let level = rawText.substring(with: rangeLevel).count
			let text = parseString(rawText.substring(with: rangeText))
			return .blockQuote(level: level, text: text)
		}
		return nil
	}
	
	func parseCodeBlockMarker(rawText: String) -> Token? {
		let pattern = #"^`{3,6}(.*)"#
		if let text = rawText.groups(for: pattern).last {
			let level = rawText.filter { $0 == "`" }.count
			return .codeBlockMarker(level: level, lang: text)
		}
		return nil
	}

	func parseBulletedListItem(rawText: String) -> Token? {
		let pattern = #"^(?<level>\h*)(?<marker>-)\s+(?<text>.+)"#
		if let match = rawText.firstMatch(pattern: pattern) {
			let rangeLevel = match.range(withName: "level")
			let rangeMarker = match.range(withName: "marker")
			let rangeText = match.range(withName: "text")
			let level = rawText.substring(with: rangeLevel).count
			let marker = rawText.substring(with: rangeMarker)
			let text = parseString(rawText.substring(with: rangeText))
			return .bulletedListItem(level: level, marker: marker, text: text)
		}
		return nil
	}

	func parseNumberedListItem(rawText: String) -> Token? {
		let pattern = #"^(?<level>\h*)(?<marker>\d+\.)\s+(?<text>.+)"#
		if let match = rawText.firstMatch(pattern: pattern) {
			let rangeLevel = match.range(withName: "level")
			let rangeMarker = match.range(withName: "marker")
			let rangeText = match.range(withName: "text")
			let level = rawText.substring(with: rangeLevel).count
			let marker = rawText.substring(with: rangeMarker)
			let text = parseString(rawText.substring(with: rangeText))
			return .numberedListItem(level: level, marker: marker, text: text)
		}
		return nil
	}

	func parseString(_ rawText: String) -> Text {
		TextParser().parse(rawText: rawText)
	}
}
