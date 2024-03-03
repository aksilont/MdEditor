//
// MdEditorTests.swift
//

import UIKit

protocol Accessible {
	func generateAccessibilityIdentifiers()
}

extension Accessible {
	
	func generateAccessibilityIdentifiers() {
#if DEBUG
		let mirror = Mirror(reflecting: self)
		
		for child in mirror.children {
			if
				let view = child.value as? UIView,
				var identifier = child.label {
				identifier = identifier.replacingOccurrences(of: ".storage", with: "")
				identifier = identifier.replacingOccurrences(of: "$__lazy_storage_$_", with: "")

				view.accessibilityIdentifier = "\(type(of: self)).\(identifier)"
			}
		}
#endif
	}
}

enum AccessibilityIdentifier {
	enum Login: CustomStringConvertible {
		case textFieldLogin
		case textFieldPass
		case buttonLogin

		var description: String {
			switch self {
			case .textFieldLogin:
				return "LoginViewController.textFieldLogin"
			case .textFieldPass:
				return "LoginViewController.textFieldPass"
			case .buttonLogin:
				return "LoginViewController.buttonLogin"
			}
		}
	}

	enum TodoList: CustomStringConvertible {
		case tableView
		case section(index: Int)
		case cell(section: Int, row: Int)

		var description: String {
			switch self {
			case .tableView:
				return "TodoListViewController.tableView"
			case .section(let index):
				return "TodoListViewController.section-\(index)"
			case .cell(let section, let row):
				return "TodoListViewController.cell-\(section)-\(row)"
			}
		}
	}

	enum FileList: CustomStringConvertible {
		case tableView
		case section(index: Int)
		case cell(section: Int, row: Int)

		var description: String {
			switch self {
			case .tableView:
				return "FileListViewController.tableView"
			case .section(let index):
				return "FileListViewController.section-\(index)"
			case .cell(let section, let row):
				return "FileListViewController.cell-\(section)-\(row)"
			}
		}
	}
	
	enum StartScreen: CustomStringConvertible {
		case collectionView
		case buttonNew
		case buttonOpen
		case buttonAbout
		
		var description: String {
			switch self {
			case .collectionView:
				return "StartScreenViewController.collectionView"
			case .buttonNew:
				return "StartScreenViewController.buttonNew"
			case .buttonOpen:
				return "StartScreenViewController.buttonOpen"
			case .buttonAbout:
				return "StartScreenViewController.buttonAbout"
			}
		}
	}
	
	enum AboutScreen {
		static let labelFileData = "AboutScreenViewController.labelFileData"
	}
}
