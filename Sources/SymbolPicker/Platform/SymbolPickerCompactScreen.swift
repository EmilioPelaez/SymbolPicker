//
//  SymbolPickerCompactScreen.swift
//  SymbolPicker
//
//  Created by Emilio Peláez on 7/5/26.
//

import SwiftUI
import UIToolKit

struct SymbolPickerCompactScreen: View {
	@Environment(\.symbolPickerLimit) var symbolPickerLimit
	@Environment(\.ignoredSymbolCategories) var ignoredSymbolCategories
	@Environment(\.symbolPickerTitle) var symbolPickerTitle

	@StateObject var symbolLoader = SymbolLoader()
	@StateObject var categoryLoader = CategoryLoader()

	let mode: SymbolPicker.Mode
	let onDone: () -> Void

	@Binding var selection: [String]

	@State var category: SymbolCategory?
	@State var searchQuery: String = ""

	var limit: Int? {
		mode == .singleSelection ? 1 : symbolPickerLimit
	}

	var filteredCategories: [SymbolCategory] {
		categoryLoader.categories.filter { !ignoredSymbolCategories.contains($0.key) }
	}

	var title: Text {
		mode == .singleSelection ? Text("Select Symbol") : Text("Select Symbols")
	}

	var body: some View {
		NavigationView {
			SymbolPickerScreen(symbols: symbolLoader.symbols,
							   category: category,
							   searchQuery: searchQuery,
							   categoryLoader: categoryLoader,
							   selection: $selection)
			.navigationTitle(symbolPickerTitle ?? title)
			.navigationBarTitleDisplayModeInline()
			.searchable(text: $searchQuery)
			.safeAreaInset(edge: .bottom) {
				if searchQuery.isEmpty {
					CategoryBar(selection: $category,
								categories: filteredCategories)
					.floatingBackground()
					.paddingMedium(.horizontal)
					.transition(.opacity)
					.animation(.linear, value: searchQuery.isEmpty)
				}
			}
			.frame(minHeight: 300, idealHeight: 600)
			.onAppear {
				category = filteredCategories.first
			}
			.toolbar {
				ToolbarItem(placement: .confirmationAction) {
					if selection.isEmpty || limit == 1 {
						ModalDismissButton(onDone)
					} else {
						Button(action: onDone) {
							Image(systemName: "checkmark")
						}
						.prominentButton()
						.tint(.blue)
					}
				}
			}
		}
		.symbolPickerLimit(limit)
		.onChange(of: selection) { _, newValue in
			if mode == .singleSelection, !newValue.isEmpty {
				onDone()
			}
		}
	}
}

#Preview {
	SymbolPickerCompactScreen(mode: .multipleSelection, onDone: {}, selection: .constant(["cat.fill"]))
}
