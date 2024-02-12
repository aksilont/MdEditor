//
//  AboutScreenPresenter.swift
//  MdEditor
//
//  Created by Aleksey Efimov on 09.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

protocol IAboutScreenPresenter {
	
	/// Отображение экрана About.
	/// - Parameter response: Подготовленные к отображению данные.
	func present(responce: AboutScreenModel.Response)
}

final class AboutScreenPresenter: IAboutScreenPresenter {
	
	// MARK: - Dependencies
	
	private weak var viewController: IAboutScreenViewController?
	
	// MARK: - Initialization
	
	init(viewController: IAboutScreenViewController?) {
		self.viewController = viewController
	}
	
	// MARK: - Public methods
	
	func present(responce: AboutScreenModel.Response) {
		let fileData = responce.fileData
		viewController?.render(viewModel: AboutScreenModel.ViewModel( fileData: fileData))
	}
}
