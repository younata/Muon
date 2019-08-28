// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Muon",
    dependencies: [
        .package(url: "https://github.com/Quick/Quick", .upToNextMinor(from: "2.1.0")),
        .package(url: "https://github.com/Quick/Nimble", .upToNextMinor(from: "8.0.2"))
    ],
    targets: [
        .target(name: "Muon", path: "Sources"),
        .testTarget(name: "MuonTests", dependencies: ["Muon", "Quick", "Nimble"])
    ]
)
