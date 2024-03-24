//
//  MainQueueDispatchConverterDecorator.swift
//  MdEditor
//
//  Created by Aksilont on 13.03.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation
import MarkdownPackage

class MainQueueDispatchConverterDecorator<T>: IMarkdownConverter {
	// MARK: - Private properties
	private let decoratee: any IMarkdownConverter

	// MARK: - Initialization
	init(_ decoratee: any IMarkdownConverter) {
		self.decoratee = decoratee
	}

	// MARK: - Public methods
	func convert(markdownText: String, completion: @escaping (T) -> Void) {
		decoratee.convert(markdownText: markdownText) { [weak self] result in
			self?.doInMainThread {
				guard let result = result as? T else { return }
				completion(result)
			}
		}
	}

	// MARK: - Private methods
	private func doInMainThread(_ work: @escaping () -> Void) {
		if Thread.isMainThread {
			work()
		} else {
			DispatchQueue.main.async(execute: work)
		}
	}
}
