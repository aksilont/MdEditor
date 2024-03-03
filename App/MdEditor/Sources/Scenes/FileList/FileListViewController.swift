//
//  FileListViewController.swift
//  MdEditor
//
//  Created by Aksilont on 31.01.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import UIKit

/// Протокол экрана открытия файла
protocol IFileListViewController: AnyObject {
	/// Метод отрисовки информации на экране.
	/// - Parameter viewModel: данные для отрисовки на экране.
	func render(viewModel: FileListModel.ViewModel)
}

final class FileListViewController: UIViewController {
	// MARK: - Dependencies
	var interactor: IFileListInteractor?

	// MARK: - Private properties
	private lazy var tableView: UITableView = makeTableView()
	private var viewModel = FileListModel.ViewModel(title: "/", data: [])

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		interactor?.fetchData()
		setupUI()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layout()
	}
}

private extension FileListViewController {
	func getFileForIndex(_ index: Int) -> FileListModel.ViewModel.FileViewModel {
		viewModel.data[index]
	}
}

// MARK: - UITableViewDelegate
extension FileListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		interactor?.performAction(request: .fileSelected(indexPath: indexPath))
	}
}

// MARK: - UITableViewDataSource
extension FileListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.data.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: FileItemTableViewCell.cellIdentifier,
			for: indexPath
		) as? FileItemTableViewCell else {
			return UITableViewCell()
		}
		cell.selectionStyle = .none

		// Accessibility: Identifier
		cell.accessibilityIdentifier = AccessibilityIdentifier.FileList.cell(
			section: indexPath.section,
			row: indexPath.row
		).description

		let fileViewModel = getFileForIndex(indexPath.row)

		cell.configure(with: fileViewModel)

		return cell
	}
}

// MARK: - Setup UI
private extension FileListViewController {
	func makeTableView() -> UITableView {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}

	/// Настройка UI экрана
	func setupUI() {
		view.backgroundColor = Theme.backgroundColor
		navigationItem.setHidesBackButton(false, animated: true)
		navigationItem.backButtonDisplayMode = .minimal
		navigationItem.largeTitleDisplayMode = .never
		navigationController?.navigationBar.tintColor = Theme.mainColor

		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(FileItemTableViewCell.self, forCellReuseIdentifier: FileItemTableViewCell.cellIdentifier)
		tableView.backgroundColor = Theme.backgroundColor

		// Accessibility: Identifier
		tableView.accessibilityIdentifier = AccessibilityIdentifier.FileList.tableView.description

		view.addSubview(tableView)
	}
}

// MARK: - Layout UI
private extension FileListViewController {
	func layout() {
		let newConstraints = [
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		]
		NSLayoutConstraint.activate(newConstraints)
	}
}

// MARK: - IFileListViewController
extension FileListViewController: IFileListViewController {
	func render(viewModel: FileListModel.ViewModel) {
		title = viewModel.title
		guard !viewModel.data.isEmpty else { return }
		self.viewModel = viewModel
		tableView.reloadData()
	}
}
