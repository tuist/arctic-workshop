// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "my-linter",
    platforms: [.macOS("13.0")],
    products: [
        .executable(name: "my-linter", targets: ["my-linter"])
    ],
    dependencies: [
        .package(url: "https://github.com/tuist/XcodeGraph", from: "1.8.9"),
        .package(url: "https://github.com/tuist/Command", from: "0.13.0"),
        .package(url: "https://github.com/tuist/FileSystem", from: "0.7.7"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "my-linter",
            dependencies: [
                .product(name: "XcodeGraph", package: "XcodeGraph"),
                .product(name: "Command", package: "Command"),
                .product(name: "FileSystem", package: "FileSystem"),
            ]
        )
    ]
)
