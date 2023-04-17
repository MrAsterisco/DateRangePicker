// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "DateRangePicker",
    platforms: [
      .iOS(.v15)
    ],
    products: [
        .library(
            name: "DateRangePicker",
            targets: ["DateRangePicker"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DateRangePicker",
            dependencies: []),
        .testTarget(
            name: "DateRangePickerTests",
            dependencies: ["DateRangePicker"]),
    ]
)
