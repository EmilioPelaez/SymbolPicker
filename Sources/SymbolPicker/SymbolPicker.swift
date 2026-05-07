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
	let singleMode: Bool
	@State private var isPresented = false

	public init(_ title: String, selection: Binding<String?>) {
		self.title = title
		self._selection = Binding(
			get: { selection.wrappedValue.map { [$0] } ?? [] },
			set: { selection.wrappedValue = $0.last }
		)
		self.singleMode = true
	}

	public init(_ title: String, selection: Binding<[String]>) {
		self.title = title
		self._selection = selection
		self.singleMode = false
	}

	var singleSymbol: Binding<String?> {
		Binding(
			get: { selection.last },
			set: { selection = $0.map { [$0] } ?? [] }
		)
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
						ForEach(selection.indices, id: \.self) { index in
							Image(systemName: selection[index])
						}
					}
				}
			}
		}
		.sheet(isPresented: $isPresented) {
			if singleMode {
				SymbolPickerScreen(symbol: singleSymbol, onDone: { isPresented = false })
			} else {
				SymbolPickerScreen(symbols: $selection)
			}
		}
	}
}
