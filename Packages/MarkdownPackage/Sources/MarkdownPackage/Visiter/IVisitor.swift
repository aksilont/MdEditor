//
//  IVisitor.swift
//  MdEditor
//
//  Created by Aleksey Efimov on 27.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

public protocol IVisitor {
	associatedtype Result
	
	func visit(_ node: Document) -> [Result]
	func visit(_ node: HeaderNode) -> Result
	func visit(_ node: BlockquoteNode) -> Result
	func visit(_ node: ParagraphNode) -> Result
	func visit(_ node: TextNode) -> Result
	func visit(_ node: BoldTextNode) -> Result
	func visit(_ node: ItalicTextNode) -> Result
	func visit(_ node: StrikeTextNode) -> Result
	func visit(_ node: HighlightedTextNode) -> Result
	func visit(_ node: BoldItalicTextNode) -> Result
	func visit(_ node: InlineCodeTextNode) -> Result
	func visit(_ node: EscapedCharTextNode) -> Result
	func visit(_ node: LinkNode) -> Result
	func visit(_ node: ImageNode) -> Result
	func visit(_ node: EmptyLineNode) -> Result
	func visit(_ node: LineBreakNode) -> Result
	func visit(_ node: HorizontalLineNode) -> Result
	func visit(_ node: CodeBlockNode) -> Result
	func visit(_ node: CodeBlockItem) -> Result
	func visit(_ node: BulletedListNode) -> Result
	func visit(_ node: BulletedListItem) -> Result
	func visit(_ node: NumberedListNode) -> Result
	func visit(_ node: NumberedListItem) -> Result
}

extension IVisitor {
	func visitChildren(of node: INode) -> [Result] {
		return node.children.compactMap { child in // swiftlint:disable:this closure_body_length
			switch child {
			case let child as HeaderNode:
				return visit(child)
			case let child as BlockquoteNode:
				return visit(child)
			case let child as ParagraphNode:
				return visit(child)
			case let child as TextNode:
				return visit(child)
			case let child as BoldTextNode:
				return visit(child)
			case let child as ItalicTextNode:
				return visit(child)
			case let child as StrikeTextNode:
				return visit(child)
			case let child as HighlightedTextNode:
				return visit(child)
			case let child as BoldItalicTextNode:
				return visit(child)
			case let child as InlineCodeTextNode:
				return visit(child)
			case let child as EscapedCharTextNode:
				return visit(child)
			case let child as LinkNode:
				return visit(child)
			case let child as ImageNode:
				return visit(child)
			case let child as EmptyLineNode:
				return visit(child)
			case let child as LineBreakNode:
				return visit(child)
			case let child as HorizontalLineNode:
				return visit(child)
			case let child as CodeBlockNode:
				return visit(child)
			case let child as CodeBlockItem:
				return visit(child)
			case let child as BulletedListNode:
				return visit(child)
			case let child as BulletedListItem:
				return visit(child)
			case let child as NumberedListNode:
				return visit(child)
			case let child as NumberedListItem:
				return visit(child)
			default:
				return nil
			}
		}
	}
}
