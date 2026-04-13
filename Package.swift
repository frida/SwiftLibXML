// swift-tools-version:5.6

import PackageDescription

let pkgName = "SwiftLibXML"

#if compiler(>=6.2)
let packageDependencies: [Package.Dependency] = [
    .package(url: "https://github.com/mipalgu/swift-docc-static.git", branch: "main")
]
#else
let packageDependencies = [Package.Dependency]()
#endif

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
let deps = [Target.Dependency]()
let cTargets = [Target]()
#else
// Linux, Windows (with vcpkg), and other platforms: use pkg-config.
let deps: [Target.Dependency] = [.target(name: "CLibXML2")]
let cTargets: [Target] = [
    .systemLibrary(
        name: "CLibXML2",
        pkgConfig: "libxml-2.0",
        providers: [
            .brew(["libxml2"]),
            .apt(["libxml2-dev"]),
        ]
    )
]
#endif

let swiftLibXMLSwiftSettings = [SwiftSetting]()

let package = Package(
    name: pkgName,
    products: [.library(name: pkgName, targets: [pkgName])],
    dependencies: packageDependencies,
    targets: cTargets + [
        .target(name: pkgName, dependencies: deps,
                swiftSettings: swiftLibXMLSwiftSettings),
        .testTarget(name: "\(pkgName)Tests", dependencies: [.target(name: pkgName)]),
    ]
)
