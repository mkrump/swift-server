// swift-tools-version:3.1

import PackageDescription

let package = Package(
        name: "SwiftServer",
        targets: [
            Target(name: "Main", dependencies: ["CommandLineParser", "Server"]),
            Target(name: "CommandLineParser"),
            Target(name: "Server")
        ],
        dependencies: [
            .Package(url: "https://github.com/IBM-Swift/BlueSocket", majorVersion: 0, minor: 12)
        ]
)
