import PackageDescription

let package = Package(
    name: "Muon",
    dependencies: [
        .Package(url: "https://github.com/Quick/Quick", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/Quick/Nimble", majorVersion: 7)
    ]
)
