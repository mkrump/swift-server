// swift-tools-version:3.1

import PackageDescription

let package = Package(
        name: "SwiftServer",
        targets: [
            Target(name: "AppRoutes",
                    dependencies: ["HTTPResponse", "HTTPRequest", "Templates", "FileSystem", "Routes"]),
            Target(name: "CommandLineParser"),
            Target(name: "Configuration",
                    dependencies: ["FileSystem", "Routes", "AppRoutes"]),
            Target(name: "FileSystem",
                    dependencies: ["SimpleURL"]),
            Target(name: "HTTPRequest",
                    dependencies: ["FileSystem", "Templates", "SimpleURL"]),
            Target(name: "HTTPResponse"),
            Target(name: "MiddleWare",
                    dependencies: ["HTTPResponse", "HTTPRequest", "Routes"]),
            Target(name: "Main",
                    dependencies: ["CommandLineParser", "Configuration", "Server"]),
            Target(name: "Routes",
                    dependencies: ["HTTPResponse", "HTTPRequest", "Templates", "FileSystem", "SimpleURL"]),
            Target(name: "Server",
                    dependencies: ["Configuration", "HTTPResponse", "HTTPRequest", "FileSystem", "Routes", "SimpleURL"]),
            Target(name: "SimpleURL"),
            Target(name: "Templates", dependencies: ["SimpleURL"])
        ],
        dependencies: [
            .Package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", majorVersion: 0),
            .Package(url: "https://github.com/IBM-Swift/BlueSocket", majorVersion: 0, minor: 12)
        ]
)
