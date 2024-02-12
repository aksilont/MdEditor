//
//  AboutScreenAssembler.swift
//  MdEditor
//
//  Created by Aleksey Efimov on 09.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

final class AboutScreenAssembler {
	
	func assembly(fileStorage: IStorageService, url: URL) -> AboutScreenViewController {
		let viewController = AboutScreenViewController()
		let presenter = AboutScreenPresenter(viewController: viewController)
		let interactor = AboutScreenInteractor(presenter: presenter, fileStorage: fileStorage, url: url)
		viewController.interactor = interactor
		
		return viewController
	}
}
