//
//  MarkdownToPdfConverter.swift
//
//
//  Created by Aleksey Efimov on 01.03.2024.
//

import Foundation
import PDFKit

enum FormatPages {
	case A3
	case A4
	case A5
	case A6

	var size: CGSize {
		switch self {
		case .A3:
			return convert(width: 297, height: 420)
		case .A4:
			return convert(width: 210, height: 297)
		case .A5:
			return convert(width: 148, height: 210)
		case .A6:
			return convert(width: 105, height: 148)
		}
	}
	
	/// Конвертация размера страницы мм -> поинты
	/// - Parameters:
	///   - width: Ширина в мм
	///   - height: Высота в мм
	/// - Returns: Размер в поинтах
	private func convert(width: CGFloat, height: CGFloat) -> CGSize {
		CGSize(width: width / 25.4 * 72, height: height / 25.4 * 72)
	}
}

public final class MarkdownToPdfConverter: IMarkdownConverter {
	enum Constants {
		static let pageRect = CGRect(origin: .zero, size: FormatPages.A4.size)
		static let initialCursorPosition: CGFloat = 20
		static let lineSpacing: CGFloat = 12
		static let indent: CGFloat = 20
	}
	
	// MARK: - Private properties
	private let markdownToDocument = MarkdownToDocument()
	private let pdfAuthor: String
	private let pdfTitle: String

	// MARK: - Initialization
	public init(pdfAuthor: String, pdfTitle: String) {
		self.pdfAuthor = pdfAuthor
		self.pdfTitle = pdfTitle
	}

	// MARK: - Public methods
	public func convert(markdownText: String, completion: @escaping (Data) -> Void) {
		DispatchQueue.global().async { [weak self] in
#if DEBUG
			// Преднамеренная задержка для демонстрации асинхронной работы
			sleep(1)
#endif
			guard let self else { return }
			let document = self.markdownToDocument.convert(markdownText: markdownText)

			let visitor = AttributedTextVisitor()
			let lines = document.accept(visitor: visitor)

			let pdfMetaData  = [
				kCGPDFContextAuthor: self.pdfAuthor,
				kCGPDFContextTitle: self.pdfTitle
			]

			let format = UIGraphicsPDFRendererFormat()
			format.documentInfo = pdfMetaData as [String: Any]

			let graphicsRenderer = UIGraphicsPDFRenderer(bounds: Constants.pageRect, format: format)

			let data = graphicsRenderer.pdfData { context in
				context.beginPage()

				var cursor: CGFloat = Constants.initialCursorPosition

				lines.forEach { line in
					// Удалим символ \n (переноса строки) в конце строки
					line.replaceCharacters(in: .init(location: line.length - 1, length: 1), with: "")
					cursor = self.addAttributedText(
						context: context,
						text: line,
						indent: Constants.indent,
						cursor: cursor,
						pdfSize: Constants.pageRect.size
					)

					cursor += Constants.lineSpacing
				}

			}

			completion(data)
		}
	}

}

private extension MarkdownToPdfConverter {
	func addAttributedText(
		context: UIGraphicsPDFRendererContext,
		text: NSAttributedString,
		indent: CGFloat,
		cursor: CGFloat,
		pdfSize: CGSize
	) -> CGFloat {
		let widthPage = pdfSize.width - 2 * indent
		let textHeight = textHeight(text, withConstrainedWidth: widthPage)
		var rect = CGRect(x: indent, y: cursor, width: widthPage, height: textHeight)

		// Перед выводом текста проверим влезает ли он на страницу
		// В противном случае - перейдем на новую страницу и
		// Определим новые координаты для текста
		if rect.maxY > (pdfSize.height - 2 * Constants.initialCursorPosition) {
			context.beginPage()
			rect.origin = CGPoint(x: indent, y: Constants.initialCursorPosition)
		}

		text.draw(in: rect)
		return rect.maxY
	}
	
	func textHeight(_ text: NSAttributedString, withConstrainedWidth width: CGFloat) -> CGFloat {
		let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
		let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
		return ceil(boundingBox.height)
	}
}
