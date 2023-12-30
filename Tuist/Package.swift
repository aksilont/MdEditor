// swift-tools-version: 5.7
import PackageDescription

let package = Package(
	name: "PackageName",
 	dependencies: [
 		.package(path: "../../../TaskManagerPackage"),
        .package(path: "../../../DataStructuresPackage")
 	]
)
