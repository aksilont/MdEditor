//
//  TextParser.swift
//  MarkdownPackage
//
//  Created by Kirill Leonov on 13.02.2024.
//

import Foundation

final class TextParser {
	private struct PartRegex {
		let type: PartType
		let regex: NSRegularExpression

		enum PartType {
			case normal
			case bold
			case italic
			case strike
			case highlighted
			case boldItalic
			case inlineCode
			case escapedChar
			case link
			case image
		}

		internal init(type: TextParser.PartRegex.PartType, pattern: String) {
			self.type = type
			self.regex = try! NSRegularExpression(pattern: pattern)
		}
	}

	private let partRegexes = [
		PartRegex(type: .escapedChar, pattern: #"^\\([\\\`\*\_\{\}\[\]\<\>\(\)\+\-\.\!\|#]){1}"#),
		PartRegex(type: .normal, pattern: #"^([^\[\!]*?)(?=[\~\=\*\!\[`\\]|$)"#),
		PartRegex(type: .boldItalic, pattern: #"^\*\*\*(.*?)\*\*\*"#),
		PartRegex(type: .bold, pattern: #"^\*\*(.*?)\*\*"#),
		PartRegex(type: .italic, pattern: #"^\*(.*?)\*"#),
		PartRegex(type: .strike, pattern: #"^\~\~(.*?)\~\~"#),
		PartRegex(type: .highlighted, pattern: #"^\=\=(.*?)\=\="#),
		PartRegex(type: .inlineCode, pattern: #"^`(.*?)`"#),
		PartRegex(type: .link, pattern: #"(?<!\!)\[([^\\]+?)\]\(([^\\]+?)\)"#),
		PartRegex(type: .image, pattern: #"!\[([^\\]+?)\]\(([^\\]+?)\)"#)
	]

	func parse(rawText text: String) -> Text {
		var parts = [Text.Part]()
		var range = NSRange(text.startIndex..., in: text)

		while range.location != NSNotFound && range.length != 0 {
			let startPartsCount = parts.count
			for partRegex in partRegexes {
				if let math = partRegex.regex.firstMatch(in: text, range: range),
				   let group0 = Range(math.range(at: 0), in: text),
				   let group1 = Range(math.range(at: 1), in: text) {

					let extractedText = String(text[group1])
					if !extractedText.isEmpty {
						switch partRegex.type {
						case .normal:
							parts.append(.normal(text: extractedText))
						case .bold:
							parts.append(.bold(text: extractedText))
						case .italic:
							parts.append(.italic(text: extractedText))
						case .strike:
							parts.append(.strike(text: extractedText))
						case .highlighted:
							parts.append(.highlighted(text: extractedText))
						case .boldItalic:
							parts.append(.boldItalic(text: extractedText))
						case .inlineCode:
							parts.append(.inlineCode(text: extractedText))
						case .escapedChar:
							parts.append(.escapedChar(char: extractedText))
						case .link:
							if let group2 = Range(math.range(at: 2), in: text) {
								let url = String(text[group2])
								parts.append(.link(header: extractedText, url: url))
							} else {
								break
							}
						case .image:
							if let group2 = Range(math.range(at: 2), in: text) {
								let url = String(text[group2])
								parts.append(.image(header: extractedText, url: url))
							} else {
								break
							}
						}

						range = NSRange(group0.upperBound..., in: text)
						break
					}
				}
			}

			if parts.count == startPartsCount {
				let extractedText = String(text[Range(range, in: text)!])
				parts.append(.normal(text: extractedText))
				break
			}
		}

		return Text(text: parts)
	}

}
