//
//  AboutScreenAssembler.swift
//  MdEditor
//
//  Created by Aleksey Efimov on 09.02.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

final class AboutScreenAssembler {
	
	func assembly(storage: IStorageService) -> AboutScreenViewController {
		let viewController = AboutScreenViewController()
		let presenter = AboutScreenPresenter(viewController: viewController)
		let interactor = AboutScreenInteractor(presenter: presenter, fileStorage: storage)
		viewController.interactor = interactor
		
		return viewController
	}
}
