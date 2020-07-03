// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CanvasView",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    
    products: [
        
        .library(
            name: "CanvasView",
            targets: ["CanvasView"]),
    ],
    dependencies: [
        .package(name: "Zinnia-Swift", url: "https://github.com/shinjukunian/zinnia-swift.git", .branch("master"))
    ],
    targets: [
        .target(name: "CanvasView", dependencies: ["Zinnia-Swift"], path: nil, exclude: [], sources: nil, publicHeadersPath: nil, cSettings: nil, cxxSettings: nil, swiftSettings: nil, linkerSettings: nil)

        
        

    ]
)
