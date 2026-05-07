//
//  View+Background.swift
//  SymbolPicker
//
//  Created by Emilio Peláez on 4/5/26.
//

import SwiftUI

extension View {
	@ViewBuilder
	func navigationBarTitleDisplayModeInline() -> some View {
		#if os(iOS)
		navigationBarTitleDisplayMode(.inline)
		#else
		self
		#endif
	}


	@ViewBuilder
	func floatingBackground() -> some View {
		if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
			glassEffect(.regular, in: .capsule)
		} else {
			background(.regularMaterial)
				.clipShape(.capsule)
		}
	}
	
	@ViewBuilder
	func prominentButton() -> some View {
		if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
			buttonStyle(.glassProminent)
		} else {
			buttonStyle(.borderedProminent)
		}
	}
}
