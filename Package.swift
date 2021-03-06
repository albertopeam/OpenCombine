// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "OpenCombine",
    products: [
        .library(name: "OpenCombine", targets: ["OpenCombine"]),
        .library(name: "OpenCombineDispatch", targets: ["OpenCombineDispatch"]),
        .library(name: "OpenCombineFoundation", targets: ["OpenCombineFoundation"]),
    ],
    targets: [
        .target(name: "COpenCombineHelpers"),
        .target(
          name: "OpenCombine", 
          dependencies: [
            .target(name: "COpenCombineHelpers", condition: .when(platforms: [.macOS, .iOS, .watchOS, .tvOS, .linux]))
          ],
          exclude: [
            "Publishers/Publishers.Encode.swift.gyb",
            "Publishers/Publishers.MapKeyPath.swift.gyb",
            "Publishers/Publishers.Catch.swift.gyb"
          ],
          swiftSettings: [.define("WASI", .when(platforms: [.wasi]))]
        ),
        .target(name: "OpenCombineDispatch", dependencies: ["OpenCombine"]),
        .target(
          name: "OpenCombineFoundation", 
          dependencies: [
            "OpenCombine",
            .target(name: "COpenCombineHelpers", condition: .when(platforms: [.macOS, .iOS, .watchOS, .tvOS, .linux]))
          ]
        ),
        .testTarget(
          name: "OpenCombineTests",
          dependencies: [
            "OpenCombine",
            .target(name: "OpenCombineDispatch", condition: .when(platforms: [.macOS, .iOS, .watchOS, .tvOS, .linux])),
            .target(name: "OpenCombineFoundation", condition: .when(platforms: [.macOS, .iOS, .watchOS, .tvOS, .linux])),
          ],
          swiftSettings: [
            .unsafeFlags(["-enable-testing"]), 
            .define("WASI", .when(platforms: [.wasi]))
          ]
        )
    ],
    cxxLanguageStandard: .cxx1z
)
