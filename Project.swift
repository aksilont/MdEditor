import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Project

let scripts: [TargetScript] = [
	Constants.swiftLintTargetScript
]

let project = Project(
	name: Constants.projectName,
	organizationName: Constants.organization,
	targets: [
		Target(
			name: Constants.projectName,
			destinations: .iOS,
			product: .app,
			bundleId: Constants.bundleId,
			deploymentTargets: .iOS("16.0"),
			infoPlist: .extendingDefault(with: Constants.extendedInfoPlist),
			sources: ["Targets/\(Constants.projectName)/**"],
			resources: ["Targets/\(Constants.projectName)/Resources/**"],
			scripts: scripts
		),
		Target(
			name: "\(Constants.projectName)Tests",
			destinations: .iOS,
			product: .unitTests,
			bundleId: "\(Constants.bundleId)Tests",
			deploymentTargets: .iOS("16.0"),
			infoPlist: .default,
			sources: ["Targets/\(Constants.projectName)Tests/**"],
			dependencies: [
				.target(name: "\(Constants.projectName)")
			])
	]
)
