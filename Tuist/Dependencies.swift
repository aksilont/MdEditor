// swift-tools-version: 5.7
import ProjectDescription

let dependencies = Dependencies(
	swiftPackageManager: .init(
		productTypes: [
			"TaskManagerPackage": .framework,
			"DataStructuresPackage": .framework
        ]
	),
	platforms: [.iOS]
)
