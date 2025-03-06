// swift-tools-version: 6.0
@preconcurrency import PackageDescription

let package = Package(
    name: "TuistApp",
    dependencies: [
        .package(id: "httpswift.swifter", .upToNextMajor(from: "1.5.0"))
    ])
