// swift-tools-version:3.1

import PackageDescription

let package = Package(
        name: "SwiftServer",
        targets: [
            Target(name: "CommandLineParser"),
            Target(name: "HTTPRequest"),
            Target(name: "Main", dependencies: ["CommandLineParser", "Server"]),
            Target(name: "HTTPResponse"),
            Target(name: "FileSystem"),
            Target(name: "Server", dependencies: ["HTTPResponse", "HTTPRequest", "Templates", "FileSystem"]),
            Target(name: "Templates")
        ],
        dependencies: [
            .Package(url: "https://github.com/IBM-Swift/BlueSocket", majorVersion: 0, minor: 12),
        ]
)
