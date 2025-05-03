// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "swift-gpio",
	products: [
		.library(
			name: "SwiftGPIO",
			targets: ["SwiftGPIO"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/fizker/SwiftyGPIO.git", branch: "fix-force-unwraps"),
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
