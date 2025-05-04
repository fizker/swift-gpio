// swift-tools-version:6.1

import PackageDescription

let package = Package(
	name: "swift-gpio",
	products: [
		.library(
			name: "SwiftGPIO",
			targets: ["SwiftGPIO"],
		),
	],
	dependencies: [
		.package(url: "https://github.com/fizker/swift-wiringpi.git", .upToNextMinor(from: "0.1.0")),
	],
	targets: [
		.target(
			name: "SwiftGPIO",
			dependencies: [
				.product(name: "WiringPi", package: "swift-wiringpi"),
			],
		),
		.testTarget(
			name: "SwiftGPIOTests",
			dependencies: ["SwiftGPIO"],
		),
	]
)
