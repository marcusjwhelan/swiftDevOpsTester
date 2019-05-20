// swift-tools-version:4.1
import PackageDescription

let package = Package(
    name: "DevOpsTester",
    products: [
        .library(name: "DevOpsTester", targets: ["App"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.3.0"),

        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
        .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0"),
        
        .package(url: "https://github.com/apple/swift-nio.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-nio-ssl.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-nio-http2.git", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-nio-transport-services.git", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-nio-extras.git", from: "0.1.0")
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentPostgreSQL", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

