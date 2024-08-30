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
    dependencies: [
			.package(url: "https://github.com/MrAsterisco/OpenDateInterval", .upToNextMajor(from: "1.0.0"))
		],
    targets: [
        .target(
            name: "DateRangePicker",
            dependencies: ["OpenDateInterval"]),
        .testTarget(
            name: "DateRangePickerTests",
            dependencies: ["DateRangePicker"]),
    ]
)
