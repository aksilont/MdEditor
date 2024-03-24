//
//  AttributetTextVisitor.swift
//  MdEditor
//
//  Created by Aleksey Efimov on 19.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

public final class AttributedTextVisitor: IVisitor {
	
	public init() { }
	
	public func visit(_ node: Document) -> [NSMutableAttributedString] {
		visitChildren(of: node)
	}
	
	public func visit(_ node: HeaderNode) -> NSMutableAttributedString {
		let code = makeMdCode(String(repeating: "#", count: node.level) + " ")
		let text = visitChildren(of: node).joined()
		
		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)

		result.addAttribute(
			.font,
			value: UIFont.systemFont(ofSize: Appearance.headerSize[node.level - 1]),
			range: NSRange(0..<result.length)
		)
		
		return result
	}
	
	public func visit(_ node: BlockquoteNode) -> NSMutableAttributedString {
		let code = makeMdCode(String(repeating: ">", count: node.level) + " ")
		let text = visitChildren(of: node).joined()
		
		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		
		return result
	}
	
	public func visit(_ node: ParagraphNode) -> NSMutableAttributedString {
		visitChildren(of: node).joined()
	}
	
	public func visit(_ node: TextNode) -> NSMutableAttributedString {
		let attribute: [NSAttributedString.Key: Any] = [
			.foregroundColor: Appearance.textColor,
			.font: UIFont.systemFont(ofSize: Appearance.textSize)
		]
		return NSMutableAttributedString(string: node.text, attributes: attribute)
	}
	
	public func visit(_ node: BoldTextNode) -> NSMutableAttributedString {
		let code = makeMdCode("**")
		
		let attribute: [NSAttributedString.Key: Any] = [
			.foregroundColor: Appearance.textBoldColor,
			.font: UIFont.boldSystemFont(ofSize: Appearance.textSize)
		]
		let text = NSMutableAttributedString(string: node.text, attributes: attribute)
		
		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		result.append(code)
		
		return result
	}
	
	public func visit(_ node: ItalicTextNode) -> NSMutableAttributedString {
		let code = makeMdCode("*")
		
		let attribute: [NSAttributedString.Key: Any] = [
			.foregroundColor: Appearance.textItalicColor,
			.font: UIFont.italicSystemFont(ofSize: Appearance.textSize)
		]
		let text = NSMutableAttributedString(string: node.text, attributes: attribute)
		
		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		result.append(code)
		
		return result
	}
	
	public func visit(_ node: StrikeTextNode) -> NSMutableAttributedString {
		let code = makeMdCode("~~")
		
		let attribute: [NSAttributedString.Key: Any] = [
			.strikethroughStyle : NSUnderlineStyle.single.rawValue,
			.foregroundColor: Appearance.textStrikeColor,
			.strikethroughColor: UIColor.red,
			.font: UIFont.systemFont(ofSize: Appearance.textSize)
		]
		let text = NSMutableAttributedString(string: node.text, attributes: attribute)
		
		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		result.append(code)
		
		return result
	}
	
	public func visit(_ node: HighlightedTextNode) -> NSMutableAttributedString {
		let code = makeMdCode("==")
		
		let attribute: [NSAttributedString.Key: Any] = [
			.backgroundColor: Appearance.highlightedTextBackground,
			.foregroundColor: Appearance.textHighlightedColor,
			.font: UIFont.systemFont(ofSize: Appearance.textSize)
		]
		let text = NSMutableAttributedString(string: node.text, attributes: attribute)
		
		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		result.append(code)
		
		return result
	}
	
	public func visit(_ node: BoldItalicTextNode) -> NSMutableAttributedString {
		let code = makeMdCode("***")
		
		let font: UIFont
		if let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
			.withSymbolicTraits([.traitBold, .traitItalic]) {
			font = UIFont(descriptor: fontDescriptor, size: Appearance.textSize)
		} else {
			font = UIFont.boldSystemFont(ofSize: Appearance.textSize)
		}
		
		let attribute: [NSAttributedString.Key: Any] = [
			.foregroundColor: Appearance.textBoldItalicColor,
			.font: font
		]
		let text = NSMutableAttributedString(string: node.text, attributes: attribute)
		
		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		result.append(code)
		
		return result
	}
	
	public func visit(_ node: InlineCodeTextNode) -> NSMutableAttributedString {
		let code = makeMdCode("`")
		
		let attribute: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.gray,
			.font: UIFont.systemFont(ofSize: Appearance.textSize)
		]
		let text = NSMutableAttributedString(string: node.code, attributes: attribute)
		
		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		result.append(code)
		
		return result
	}
	
	public func visit(_ node: EscapedCharTextNode) -> NSMutableAttributedString {
		let code = makeMdCode("\\")
		
		let attribute: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.gray,
			.font: UIFont.systemFont(ofSize: Appearance.textSize)
		]
		let text = NSMutableAttributedString(string: node.char, attributes: attribute)
		
		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		
		return result
	}
	
	public func visit(_ node: LinkNode) -> NSMutableAttributedString {
		let codeFirst = makeMdCode("[")
		let codeMid = makeMdCode("](")
		let codeEnd = makeMdCode(")")
		
		let attributeTitle: [NSAttributedString.Key: Any] = [
			.foregroundColor: Appearance.linkTitleColor,
			.font: UIFont.systemFont(ofSize: Appearance.textSize)
		]
		let titleLink = NSMutableAttributedString(string: node.header, attributes: attributeTitle)
		
		let attributeLink: [NSAttributedString.Key: Any] = [
			.foregroundColor: Appearance.linkColor,
			.underlineStyle: NSUnderlineStyle.single.rawValue,
			.font: UIFont.systemFont(ofSize: Appearance.textSize)
		]
		let link = NSMutableAttributedString(string: node.url, attributes: attributeLink)
		link.addAttribute(.link, value: node.url, range: NSRange(0..<link.length))
		
		let result = NSMutableAttributedString()
		result.append(codeFirst)
		result.append(titleLink)
		result.append(codeMid)
		result.append(link)
		result.append(codeEnd)
		
		return result
	}
	
	public func visit(_ node: ImageNode) -> NSMutableAttributedString {
		let codeFirst = makeMdCode("![")
		let codeSecond = makeMdCode("|")
		let codeThird = makeMdCode("](")
		let codeEnd = makeMdCode(")")
		
		let attribute: [NSAttributedString.Key: Any] = [
			.foregroundColor: Appearance.linkTitleColor,
			.font: UIFont.systemFont(ofSize: Appearance.textSize)
		]
		let title = NSMutableAttributedString(string: node.header, attributes: attribute)
		let size = NSMutableAttributedString(string: node.size, attributes: attribute)
		
		let attributeLink: [NSAttributedString.Key: Any] = [
			.foregroundColor: Appearance.linkColor,
			.underlineStyle: NSUnderlineStyle.single.rawValue,
			.font: UIFont.systemFont(ofSize: Appearance.textSize)
		]
		let link = NSMutableAttributedString(string: node.url, attributes: attributeLink)
		link.addAttribute(.link, value: node.url, range: NSRange(0..<link.length))
		
		let result = NSMutableAttributedString()
		result.append(codeFirst)
		result.append(title)
		if node.size != "" {
			result.append(codeSecond)
			result.append(size)
		}
		result.append(codeThird)
		result.append(link)
		result.append(codeEnd)
		
		return result
	}
	
	public func visit(_ node: EmptyLineNode) -> NSMutableAttributedString {
		let string = String.lineBreak
		string.addAttribute(
			.font,
			value: UIFont.systemFont(ofSize: Appearance.textSize),
			range: NSRange(0..<string.length)
		)
		return string
	}

	public func visit(_ node: LineBreakNode) -> NSMutableAttributedString {
		String.lineBreak
	}

	public func visit(_ node: HorizontalLineNode) -> NSMutableAttributedString {
		let line = "____________"
		let attribute: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.gray,
			.font: UIFont.systemFont(ofSize: Appearance.textSize)
		]
		let result = NSMutableAttributedString(string: line, attributes: attribute)
		result.append(String.lineBreak)
		return result
	}
	
	public func visit(_ node: CodeBlockNode) -> NSMutableAttributedString {
		let codeStart = makeMdCode("```\(node.language)")
		let codeEnd = makeMdCode("```")
		
		let text = visitChildren(of: node).joined()
		
		let result = NSMutableAttributedString()
		result.append(codeStart)
		result.append(String.lineBreak)

		result.append(text)

		result.append(codeEnd)
		result.append(String.lineBreak)

		let attribute: [NSAttributedString.Key: Any] = [
			.foregroundColor: Appearance.codeBlockColor
		]
		result.addAttributes(attribute, range: NSRange(0..<result.length))
		
		return result
	}

	public func visit(_ node: CodeBlockItem) -> NSMutableAttributedString {
		let attribute: [NSAttributedString.Key: Any] = [
			.foregroundColor: Appearance.codeBlockColor,
			.font: UIFont.systemFont(ofSize: Appearance.textSize)
		]
		let text = NSMutableAttributedString(string: node.code, attributes: attribute)
		let result = NSMutableAttributedString()
		result.append(text)

		return result
	}

	public func visit(_ node: BulletedListNode) -> NSMutableAttributedString {
		let level = String(repeating: "  ", count: node.level)
		let text = visitChildren(of: node).joined(separator: level)
		
		let result = NSMutableAttributedString()
		result.append(text)
		
		return result
	}
	
	public func visit(_ node: BulletedListItem) -> NSMutableAttributedString {
		let code = makeMdCode(node.marker + " ")
		
		let text = visitChildren(of: node).joined()
		
		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		
		return result
	}
	
	public func visit(_ node: NumberedListNode) -> NSMutableAttributedString {
		let level = String(repeating: "  ", count: node.level)
		let text = visitChildren(of: node).joined(separator: level)
		
		let result = NSMutableAttributedString()
		result.append(text)
		
		return result
	}
	
	public func visit(_ node: NumberedListItem) -> NSMutableAttributedString {
		let code = makeMdCode(node.marker + " ")
		
		let text = visitChildren(of: node).joined()
		
		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		
		return result
	}
}

private extension AttributedTextVisitor {
	func makeMdCode(_ code: String) -> NSMutableAttributedString {
		let attribute: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.brown,
			.font: UIFont.systemFont(ofSize: Appearance.textSize)
		]
		return NSMutableAttributedString(string: code, attributes: attribute)
	}
}

// MARK: - Appearance

private extension AttributedTextVisitor {
	enum Appearance {
		static let markdownCodeColor: UIColor = Colors.brownText
		static let codeBlockColor: UIColor = Colors.grayText
		static let highlightedTextBackground: UIColor = .systemOrange
		static let textColor: UIColor = Colors.mainText
		static let textBoldColor: UIColor = Colors.mainText
		static let textBoldItalicColor: UIColor = Colors.mainText
		static let textItalicColor: UIColor = Colors.mainText
		static let textStrikeColor: UIColor = Colors.mainText
		static let textHighlightedColor: UIColor = .black
		static let linkColor: UIColor = Colors.linkText
		static let linkTitleColor: UIColor = Colors.redText
		static let headerColor: [UIColor] = [.black, .black, .black, .black, .black, .black]
		
		static let textSize: CGFloat = 18
		static let headerSize: [CGFloat] = [40, 30, 26, 22, 20, 18]
	}
	
	enum Colors {
		static let mainText = UIColor.color(
			light: UIColor(red: 25 / 255, green: 25 / 255, blue: 25 / 255, alpha: 1),
			dark: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
		)
		
		static let linkText = UIColor.color(
			light: UIColor(red: 86 / 255, green: 72 / 255, blue: 163 / 255, alpha: 1),
			dark: UIColor(red: 142 / 255, green: 131 / 255, blue: 194 / 255, alpha: 1)
		)
		
		static let redText = UIColor.color(
			light: UIColor(red: 193 / 255, green: 62 / 255, blue: 42 / 255, alpha: 1),
			dark: UIColor(red: 239 / 255, green: 136 / 255, blue: 118 / 255, alpha: 1)
		)
		
		static let brownText = UIColor.color(
			light: UIColor(red: 151 / 255, green: 124 / 255, blue: 51 / 255, alpha: 1),
			dark: UIColor(red: 196 / 255, green: 153 / 255, blue: 111 / 255, alpha: 1)
		)
		
		static let grayText = UIColor.color(
			light: .gray,
			dark: .lightGray
		)
	}
}
