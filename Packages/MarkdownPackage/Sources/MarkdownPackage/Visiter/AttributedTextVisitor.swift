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
		let string = String.lineBreak
		string.addAttribute(
			.font,
			value: UIFont.systemFont(ofSize: Appearance.textSize),
			range: NSRange(0..<string.length)
		)
		
		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)

		result.addAttribute(
			.font,
			value: UIFont.systemFont(ofSize: Appearance.headerSize[node.level - 1]),
			range: NSRange(0..<result.length)
		)
		result.append(string)
		
		return result
	}
	
	public func visit(_ node: BlockquoteNode) -> NSMutableAttributedString {
		let code = makeMdCode(String(repeating: ">", count: node.level) + " ")
		let text = visitChildren(of: node).joined()
		
		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		result.append(String.lineBreak)
		
		return result
	}
	
	public func visit(_ node: ParagraphNode) -> NSMutableAttributedString {
		let result = visitChildren(of: node).joined()
		result.append(String.lineBreak)
		
		return result
	}
	
	public func visit(_ node: TextNode) -> NSMutableAttributedString {
		let attribute: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.black,
			.font: UIFont.systemFont(ofSize: Appearance.textSize)
		]
		return NSMutableAttributedString(string: node.text, attributes: attribute)
	}
	
	public func visit(_ node: BoldTextNode) -> NSMutableAttributedString {
		let code = makeMdCode("**")
		
		let attribute: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.blue,
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
			.foregroundColor: UIColor.blue,
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
			.foregroundColor: UIColor.blue,
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
		let codeFirst = makeMdCode("[\(node.header)](")
		let codeEnd = makeMdCode(")")
		
		let attribute: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.blue,
			.underlineStyle: NSUnderlineStyle.single.rawValue,
			.font: UIFont.systemFont(ofSize: Appearance.textSize)
		]
		let link = NSMutableAttributedString(string: node.url, attributes: attribute)
		link.addAttribute(.link, value: node.url, range: NSRange(0..<link.length))
		
		let result = NSMutableAttributedString()
		result.append(codeFirst)
		result.append(link)
		result.append(codeEnd)
		
		return result
	}
	
	public func visit(_ node: ImageNode) -> NSMutableAttributedString {
		let codeFirst = makeMdCode("![\(node.header)|\(node.size)](")
		let codeEnd = makeMdCode(")")
		
		let attribute: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.blue,
			.underlineStyle: NSUnderlineStyle.single.rawValue,
			.font: UIFont.systemFont(ofSize: Appearance.textSize)
		]
		let link = NSMutableAttributedString(string: node.url, attributes: attribute)
		link.addAttribute(.link, value: node.url, range: NSRange(0..<link.length))
		
		let result = NSMutableAttributedString()
		result.append(codeFirst)
		result.append(link)
		result.append(codeEnd)
		
		return result
	}
	
	public func visit(_ node: LineBreakNode) -> NSMutableAttributedString {
		let string = String.lineBreak
		string.addAttribute(
			.font,
			value: UIFont.systemFont(ofSize: Appearance.textSize),
			range: NSRange(0..<string.length)
		)
		return string
	}
	
	public func visit(_ node: HorizontalLineNode) -> NSMutableAttributedString {
//		let attribute: [NSAttributedString.Key: Any] = [
//			.strikethroughStyle: NSUnderlineStyle.single.rawValue,
//			.strikethroughColor: UIColor.gray
//		]
//		let result = NSMutableAttributedString(string: "\n\r\u{00A0} \u{0009} \u{00A0}\n\n", attributes: attribute)
		let result = NSMutableAttributedString()
		return result
	}
	
	public func visit(_ node: CodeBlockNode) -> NSMutableAttributedString {
		let codeStart = makeMdCode("```\(node.language)")
		let codeEnd = makeMdCode("```")
		
		let text = visitChildren(of: node).joined(separator: "\n")
		
		let result = NSMutableAttributedString()
		result.append(codeStart)
		result.append(text)
		result.append(String.lineBreak)
		result.append(codeEnd)
		result.append(String.lineBreak)
		
		let attribute: [NSAttributedString.Key: Any] = [
			.foregroundColor: Appearance.codeBlockColor
		]
		result.addAttributes(attribute, range: NSRange(0..<result.length))
		
		return result
	}
	
	public func visit(_ node: BulletedListNode) -> NSMutableAttributedString {
		let level = String(repeating: "  ", count: node.level)
		let text = visitChildren(of: node).joined(separator: "\n" + level)
		
		let result = NSMutableAttributedString()
		result.append(text)
		
		return result
	}
	
	public func visit(_ node: BulletedListItem) -> NSMutableAttributedString {
		let attribute: [NSAttributedString.Key: Any] = [
			.font: UIFont.systemFont(ofSize: Appearance.textSize)
		]
		let code = NSAttributedString(string: node.marker + " ", attributes: attribute)
		
		let text = visitChildren(of: node).joined()
		
		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		
		return result
	}
	
	public func visit(_ node: NumberedListNode) -> NSMutableAttributedString {
		let level = String(repeating: "  ", count: node.level)
		let text = visitChildren(of: node).joined(separator: "\n" + level)
		
		let result = NSMutableAttributedString()
		result.append(text)
		
		return result
	}
	
	public func visit(_ node: NumberedListItem) -> NSMutableAttributedString {
		let attribute: [NSAttributedString.Key: Any] = [
			.font: UIFont.systemFont(ofSize: Appearance.textSize)
		]
		let code = NSAttributedString(string: node.marker + " ", attributes: attribute)
		
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
		static let markdownCodeColor: UIColor = UIColor(red: 200, green: 150, blue: 107, alpha: 1)
		static let codeBlockColor: UIColor = .gray
		static let highlightedTextBackground: UIColor = .systemOrange
		static let textSize: CGFloat = 18
		static let textColor: UIColor = .black
		static let textBoldColor: UIColor = .black
		static let textBoldItalicColor: UIColor = .black
		static let textItalicColor: UIColor = .black
		static let headerSize: [CGFloat] = [40, 30, 26, 22, 20, 18]
		static let headerColor: [UIColor] = [.black, .black, .black, .black, .black, .black]
	}
}
