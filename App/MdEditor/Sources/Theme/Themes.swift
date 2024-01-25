//
//  Themes.swift
//  MdEditor
//
//  Created by Aksilont on 14.01.2024.
//

import UIKit

/// Возможные темы приложения
enum Themes {
	case modern
	case dark

	var colors: IThemeSetsColor {
		switch self {
		case .modern:
			return ThemeModern()
		case .dark:
			return ThemeDark()
		}
	}
}

/// Протокол для тем с набором цветов
protocol IThemeSetsColor {
	/// Главный цвет темы, например, цвет фона кнопок
	var mainColor: UIColor { get }
	/// Акцентый цвет
	var accentColor: UIColor { get }
	/// Цвет оттенка (курсора) текстовых полей, кнопок и т.д.
	var tintColor: UIColor { get }
	/// Цвет текста в ячейках таблицы
	var textColor: UIColor { get }
	/// Второстепенный цвет
	var secondaryTextColor: UIColor { get }
	/// Цвет важного текста
	var importantColor: UIColor { get }
	/// Цвет оттенка в ячейках таблицы
	var tintColorCell: UIColor { get }
	/// Цвет фона
	var backgroundColor: UIColor { get }
	/// Цвет рамок текстовых полей
	var borderColor: UIColor { get }

	/// Стандартные цвет: белый
	var white: UIColor { get }
	/// Стандартные цвет: черный
	var black: UIColor { get }
}

/// Стандартные цвета
extension IThemeSetsColor {
	var white: UIColor { Colors.white }
	var black: UIColor { Colors.black }
}

struct ThemeModern: IThemeSetsColor {
	let mainColor = Colors.purple
	let accentColor = Colors.purple
	let tintColor = Colors.orange
	let textColor = Colors.black
	let secondaryTextColor = Colors.purple
	let importantColor = Colors.red
	let tintColorCell = Colors.green
	let backgroundColor = Colors.white
	let borderColor = Colors.purple
}

struct ThemeDark: IThemeSetsColor {
	let mainColor = Colors.light
	let accentColor = Colors.dark
	let tintColor = Colors.dark
	let textColor = Colors.dark
	let secondaryTextColor = Colors.dark
	let importantColor = Colors.red
	let tintColorCell = Colors.dark
	let backgroundColor = Colors.white
	let borderColor = Colors.dark
}

/// Обеспечивает доступ к цветовым темам приложения
class ThemeProvider {
	// MARK: - Properties
	var theme: Themes

	// MARK: - Static properties
	/// Свойство для быстрого доступа к цветам синглтона
	static var colors: IThemeSetsColor { shared.theme.colors }
	/// Синглитон для доступности темы по всему приложению
	static let shared = ThemeProvider()

	// MARK: - Initializer
	init(theme: Themes = .dark) {
		self.theme = theme
	}
}
