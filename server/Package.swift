// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("StrictConcurrency"),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("MemberImportVisibility"),
]

let package = Package(
    name: "Server",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .executable(
            name: "Server", 
            targets: ["Server"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log", from: "1.0.0"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.1.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.0.0"),
        .package(url: "https://github.com/hummingbird-project/swift-openapi-hummingbird", from: "2.0.0"),
        .package(url: "https://github.com/hummingbird-project/hummingbird", from: "2.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "Server",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "OpenAPIHummingbird", package: "swift-openapi-hummingbird"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "Logging", package: "swift-log"),
            ],
            plugins: [
                .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator"),
            ]
        ),
        .testTarget(
            name: "ServerTests",
            dependencies: [
                .target(name: "Server"),
                .product(name: "HummingbirdTesting", package: "hummingbird")
            ]
        ),
    ]
)

for target in package.targets {
    target.swiftSettings = swiftSettings
}
