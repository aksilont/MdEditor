import ProjectDescription

// MARK: - Constants

public enum Constants {
	public static let organization = "0ver[oder$"
	public static let projectName = "MdEditor"
	public static var bundleId: String {
		"com.aksilont.\(projectName)"
	}
	public static let extendedInfoPlist: [String: Plist.Value] = [
		"CFBundleShortVersionString": "1.0",
		"CFBundleVersion": "1",
		"UIMainStoryboardFile": "",
		"UILaunchStoryboardName": "LaunchScreen",
		"UIApplicationSceneManifest": [
			"UIApplicationSupportsMultipleScenes": false,
			"UISceneConfigurations": [
				"UIWindowSceneSessionRoleApplication": [
					[
						"UISceneConfigurationName": "Default Configuration",
						"UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
					]
				]
			]
		]
	]
	public static var swiftLintTargetScript: TargetScript {
		let swiftLintScriptString = """
			export PATH="$PATH:/opt/homebrew/bin"
			if which swiftlint > /dev/null; then
			  swiftlint
			else
			  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
			  exit 1
			fi
			"""

		return TargetScript.pre(
			script: swiftLintScriptString,
			name: "Run SwiftLint",
			basedOnDependencyAnalysis: false
		)
	}
}
