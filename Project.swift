import ProjectDescription

// MARK: - Project

private let organization = "EncodedTeam"
private let projectName = "MdEditor"

private var bundleId: String {
	"com.encoders.\(projectName)"
}

private var swiftLintTargetScript: TargetScript {
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

private let scripts: [TargetScript] = [
	swiftLintTargetScript
]

let project = Project(
	name: projectName,
	organizationName: organization,
	targets: [
		Target(
			name: projectName,
			destinations: .iOS,
			product: .app,
			bundleId: bundleId,
			deploymentTargets: .iOS("16.0"),
			infoPlist: "Targets/\(projectName)/Environments/Info.plist",
			sources: ["Targets/\(projectName)/**"],
			resources: ["Targets/\(projectName)/Resources/**"],
			scripts: scripts,
			dependencies: [
				.external(name: "TaskManagerPackage"),
				.external(name: "DataStructuresPackage")
			]
		),
		Target(
			name: "\(projectName)Tests",
			destinations: .iOS,
			product: .unitTests,
			bundleId: "\(bundleId)Tests",
			deploymentTargets: .iOS("16.0"),
			infoPlist: "Targets/\(projectName)Tests/Environments/Tests-Info.plist",
			sources: ["Targets/\(projectName)Tests/**"],
			dependencies: [
				.target(name: "\(projectName)")
			])
	]
)
