// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ToDoAppFileCache",
    products: [
        .library(
            name: "ToDoAppFileCache",
            targets: ["ToDoAppFileCache"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ToDoAppFileCache",
            dependencies: []),
        .testTarget(
            name: "ToDoAppFileCacheTests",
            dependencies: ["ToDoAppFileCache"])
    ]
)
