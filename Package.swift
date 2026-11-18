// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "VeggieKit",
    defaultLocalization: "zh-Hant",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "VeggieKit", targets: ["VeggieKit"])
    ],
    targets: [
        .target(
            name: "VeggieKit",
            resources: [.process("Resources")]
        )
    ]
)
