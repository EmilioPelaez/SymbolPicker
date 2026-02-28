//
//  SymbolPicker.swift
//  SymbolPicker
//
//  Created by Emilio Peláez on 28/2/26.
//

import SwiftUI

public struct SymbolPicker: View {
	let title: String
	@Binding var selection: [String]
	@State private var isPresented = false

	public init(_ title: String, selection: Binding<[String]>) {
		self.title = title
		self._selection = selection
	}

	public var body: some View {
		Button {
			isPresented = true
		}
		label: {
			LabeledContent(title) {
				if selection.isEmpty {
					Image(systemName: .emptySymbolSelectionSystemImage)
						.foregroundStyle(.tertiary)
				} else {
					HStack {
						ForEach(selection.enumerated(), id: \.offset) { _, symbol in
							Image(systemName: symbol)
						}
					}
				}
			}
		}
		.sheet(isPresented: $isPresented) {
			SymbolPickerScreen(symbols: $selection)
		}
	}
}
