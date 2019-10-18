// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Muon",
    products: [
        .library(name: "Muon", targets: ["Muon"]),
    ],
    targets: [
        .target(name: "Muon", path: "Sources"),
        .testTarget(name: "MuonTests", dependencies: ["Muon"])
    ],
    swiftLanguageVersions: [.v5]
)
