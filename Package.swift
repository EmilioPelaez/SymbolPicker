// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "SymbolPicker",
	defaultLocalization: "en",
	platforms: [.iOS(.v17), .macOS(.v14)],
	products: [
		.library(
			name: "SymbolPicker",
			targets: ["SymbolPicker"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/EmilioPelaez/ToolKit", from: .init(0, 0, 0)),
		.package(url: "https://github.com/EmilioPelaez/CGMath", from: .init(1, 0, 0)),
	],
	targets: [
		.target(
			name: "SymbolPicker",
			dependencies: [
				.product(name: "ToolKit", package: "ToolKit"),
				.product(name: "UIToolKit", package: "ToolKit"),
				.product(name: "CGMath", package: "CGMath"),
			],
			resources: [.process("Resources")]
		),
	]
)
