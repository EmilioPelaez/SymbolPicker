//
//  SymbolPickerWideScreen.swift
//  SymbolPicker
//
//  Created by Emilio Peláez on 7/5/26.
//

import SwiftUI
import UIToolKit

struct SymbolPickerWideScreen: View {
	@Environment(\.symbolPickerLimit) var symbolPickerLimit
	@Environment(\.ignoredSymbolCategories) var ignoredSymbolCategories

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

	var body: some View {
		VStack(spacing: 0) {
			HStack {
				SearchBar(query: $searchQuery)
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
			.paddingMedium()
			Divider()
			SymbolPickerScreen(symbols: symbolLoader.symbols,
							   category: category,
							   searchQuery: searchQuery,
							   categoryLoader: categoryLoader,
							   selection: $selection)
			Divider()
			CategoryBar(selection: $category,
						categories: filteredCategories)
		}
		.symbolPickerLimit(limit)
		.frame(minWidth: 600, minHeight: 450)
		.onAppear {
			category = filteredCategories.first
		}
		.onChange(of: selection) { _, newValue in
			if mode == .singleSelection, !newValue.isEmpty {
				onDone()
			}
		}
	}
}

#Preview {
	SymbolPickerWideScreen(mode: .multipleSelection, onDone: {}, selection: .constant(["cat.fill"]))
}
