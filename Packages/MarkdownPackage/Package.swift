// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MarkdownPackage",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MarkdownPackage",
            targets: ["MarkdownPackage"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MarkdownPackage"),
        .testTarget(
            name: "MarkdownPackageTests",
            dependencies: ["MarkdownPackage"]),
    ]
)

// For #available(iOS 16, macOS 13, *)
// Возможность использования Regex с литералами
for target in package.targets {
	target.swiftSettings = target.swiftSettings ?? []
	target.swiftSettings?.append(
		.unsafeFlags([
			"-enable-bare-slash-regex",
		])
	)
}
