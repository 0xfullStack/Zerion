// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Zerion",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Zerion",
            targets: ["Zerion"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Modularize-Packages/Infura.git", branch: "master"),
        .package(name: "SocketIO", url: "https://github.com/socketio/socket.io-client-swift", .revision("a1ed825835a2d8c2555938e96557ccc05e4bebf3")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Zerion",
            dependencies: [
                .byName(name: "Infura"),
                .byName(name: "SocketIO")
            ]),
        .testTarget(
            name: "ZerionTests",
            dependencies: ["Zerion"]),
    ]
)
