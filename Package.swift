// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Muon",
    dependencies: [
        .package(url: "https://github.com/Quick/Quick", .upToNextMinor(from: "1.3.2")),
        .package(url: "https://github.com/Quick/Nimble", .upToNextMinor(from: "7.3.1"))
    ],
    targets: [
        .target(name: "Muon", path: "Sources"),
        .testTarget(name: "MuonTests", dependencies: ["Muon", "Quick", "Nimble"])
    ]
)
