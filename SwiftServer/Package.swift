// swift-tools-version:3.1

import PackageDescription

let package = Package(
        name: "SwiftServer",
        targets: [
            Target(name: "CommandLineParser"),
            Target(name: "HTTPRequest", dependencies: ["FileSystem", "Templates"]),
            Target(name: "Main", dependencies: ["CommandLineParser", "Server"]),
            Target(name: "HTTPResponse"),
            Target(name: "FileSystem"),
            Target(name: "Routes", dependencies: ["HTTPResponse", "HTTPRequest", "Templates", "FileSystem"]),
            Target(name: "Server", dependencies: ["HTTPResponse", "HTTPRequest", "FileSystem", "Routes", "AppRoutes"]),
            Target(name: "Templates"),
            Target(name: "AppRoutes", dependencies: ["HTTPResponse", "HTTPRequest", "Templates", "FileSystem", "Routes"]),
            Target(name: "MocksTests", dependencies: ["HTTPResponse", "HTTPRequest", "FileSystem", "Routes"])
        ],
        dependencies: [
            .Package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", majorVersion: 0),
            .Package(url: "https://github.com/IBM-Swift/BlueSocket", majorVersion: 0, minor: 12),
        ]
)
