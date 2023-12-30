// swift-tools-version: 5.7
import PackageDescription

let package = Package(
	name: "PackageName",
 	dependencies: [
 		.package(path: "../../../Packages/TaskManagerPackage"),
        .package(path: "../../../Packages/DataStructuresPackage"),
 	],
	targets: [
		.target(
			name: "TaskManagerPackage",
			dependencies: []),
		.testTarget(
			name: "TaskManagerPackageTests",
			dependencies: ["TaskManagerPackage"]),
	]
)
