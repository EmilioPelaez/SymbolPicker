//
//  SymbolPicker.swift
//  SymbolPicker
//
//  Created by Emilio Peláez on 28/2/26.
//

import SwiftUI

public struct SymbolPicker: View {
	let title: Text
	let mode: Mode
	@Binding var selection: [String]
	@State private var isPresented = false

	public init(_ titleKey: LocalizedStringKey, selection: Binding<String?>) {
		self.title = Text(titleKey)
		self._selection = Binding(
			get: { selection.wrappedValue.map { [$0] } ?? [] },
			set: { selection.wrappedValue = $0.last }
		)
		self.mode = .singleSelection
	}

	public init(_ titleKey: LocalizedStringKey, selection: Binding<[String]>) {
		self.title = Text(titleKey)
		self._selection = selection
		self.mode = .multipleSelection
	}

	public init<S: StringProtocol>(_ title: S, selection: Binding<String?>) {
		self.title = Text(verbatim: String(title))
		self._selection = Binding(
			get: { selection.wrappedValue.map { [$0] } ?? [] },
			set: { selection.wrappedValue = $0.last }
		)
		self.mode = .singleSelection
	}

	public init<S: StringProtocol>(_ title: S, selection: Binding<[String]>) {
		self.title = Text(verbatim: String(title))
		self._selection = selection
		self.mode = .multipleSelection
	}

	public var body: some View {
		Button {
			isPresented = true
		}
		label: {
			LabeledContent {
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
			} label: {
				title
			}
		}
		.popover(isPresented: $isPresented) {
			#if os(iOS)
			SymbolPickerCompactScreen(mode: mode, onDone: { isPresented = false }, selection: $selection)
			#else
			SymbolPickerWideScreen(mode: mode, onDone: { isPresented = false }, selection: $selection)
			#endif
		}
	}
}
