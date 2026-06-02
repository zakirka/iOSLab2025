// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "StorageKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "StorageKit", targets: ["StorageKit"]),
    ],
    targets: [
        .target(name: "StorageKit", dependencies: [])
    ]
)
