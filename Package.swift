// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "swift-gpio",
	platforms: [
		.iOS(.v10),
		.macOS(.v10_12),
		.tvOS(.v10),
		.watchOS(.v3),
	],
	products: [
		.library(
			name: "SwiftGPIO",
			targets: ["SwiftGPIO"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/fizker/SwiftyGPIO.git", from: "1.4.5-unwrap-optionals"),
	],
	targets: [
		.target(
			name: "SwiftGPIO",
			dependencies: [
				"SwiftyGPIO",
			]
		),
		.testTarget(
			name: "SwiftGPIOTests",
			dependencies: ["SwiftGPIO"]
		),
	]
)
