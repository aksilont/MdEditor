//
//  ResourcesBundle.swift
//  MdEditor
//
//  Created by Aksilont on 01.03.2024.
//  Copyright © 2024 EncodedTeam. All rights reserved.
//

import Foundation

enum ResourcesBundle {
	static let assets = "Assets"
	static let about = "about.md"
	static let extMD = "md"

	static let bundle = Bundle.main.resourceURL ?? Bundle.main.bundleURL
	static let bundlePath = Bundle.main.resourcePath ?? Bundle.main.bundlePath
	static let aboutFile = bundle.appendingPathComponent(about)

	static var defaultUrls: [URL] {
		var urls: [URL] = []
		let bundleUrl = Bundle.main.resourceURL
		if let docsURL = bundleUrl?.appendingPathComponent(assets) {
			urls.append(docsURL)
		}
		if let homeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			urls.append(homeURL)
		}
		return urls
	}
}
