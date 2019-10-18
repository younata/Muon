// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Muon",
    products: [
        .library(name: "Muon", targets: ["Muon"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick", .upToNextMinor(from: "2.2.0")),
        .package(url: "https://github.com/Quick/Nimble", .upToNextMinor(from: "8.0.4"))
    ],
    targets: [
        .target(name: "Muon", path: "Sources"),
        .testTarget(name: "MuonTests", dependencies: ["Muon", "Quick", "Nimble"])
    ],
    swiftLanguageVersions: [.v5]
)
