//
//  PopoverViewController.swift
//  MdEditor
//
//  Created by Aksilont on 11.03.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit
import Combine

class PopoverViewController: UITableViewController {
	enum Actions: String, CaseIterable {
		case exportToPDF = "Export to PDF"
	}

	let performActionPublisher = PassthroughSubject<Actions, Never>()

	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = Theme.backgroundColor
		tableView.separatorStyle = .none
	}

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		preferredContentSize = CGSize(width: 150, height: tableView.contentSize.height)
	}

	// MARK: - Data Source, Delegate
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		Actions.allCases.count
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performActionPublisher.send(Actions.allCases[indexPath.row])
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var configuration = UITableViewCell().defaultContentConfiguration()
		configuration.text = Actions.allCases[indexPath.row].rawValue
		let cell = UITableViewCell()
		cell.selectionStyle = .none
		cell.contentConfiguration = configuration
		return cell
	}
}
