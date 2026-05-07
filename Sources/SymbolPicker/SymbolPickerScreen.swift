//
//  Created by Emilio Peláez on 4/8/24.
//

import SwiftUI
import UIToolKit

public struct SymbolPickerScreen: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.symbolPickerLimit) var symbolPickerLimit
	@Environment(\.ignoredSymbolCategories) var ignoredSymbolCategories
	@Environment(\.symbolPickerTitle) var symbolPickerTitle
	
	@StateObject var symbolLoader = SymbolLoader()
	@StateObject var categoryLoader = CategoryLoader()
	
	@Binding var selection: [String]
	let onDone: (() -> Void)?
	let singleMode: Bool
	
	@State var category: SymbolCategory?
	@State var searchQuery: String = ""
	
	public init(symbol: Binding<String?>, onDone: (() -> Void)? = nil) {
		self._selection = Binding(
			get: { symbol.wrappedValue.map { [$0] } ?? [] },
			set: { symbol.wrappedValue = $0.last }
		)
		self.onDone = onDone
		self.singleMode = true
	}
	
	public init(symbols: Binding<[String]>, onDone: (() -> Void)? = nil) {
		self._selection = .init(projectedValue: symbols)
		self.onDone = onDone
		self.singleMode = false
	}
	
	var limit: Int? {
		singleMode ? 1 : symbolPickerLimit
	}

	var filteredCategories: [SymbolCategory] {
		categoryLoader.categories.filter { !ignoredSymbolCategories.contains($0.key) }
	}
	
	var title: Text {
		switch limit {
		case .some(1): Text("Select Symbol")
		case .none: Text("Select Symbols")
		case .some(let value): Text("Select Symbols (\(selection.count)/\(value))")
		}
	}
	
	public var body: some View {
		NavigationView {
			ScrollViewReader { proxy in
				ScrollView {
					Color.clear
						.frame(height: 0)
						.id("top")
					if !searchQuery.isEmpty {
						SymbolSearchView(symbols: symbolLoader.symbols,
														 query: searchQuery,
														 selection: $selection)
						.paddingMedium()
					} else if let category {
						SymbolCategoryView(symbols: symbolLoader.symbols,
															 selection: $selection,
															 category: category,
															 loader: categoryLoader)
						.paddingMedium()
					} else {
						ProgressView()
							.progressViewStyle(.circular)
					}
				}
				.onChange(of: searchQuery) {
					proxy.scrollTo("top", anchor: .top)
				}
			}
			.navigationTitle(symbolPickerTitle ?? title)
			#if !os(macOS)
			.navigationBarTitleDisplayMode(.inline)
			#endif
			.searchable(text: $searchQuery)
			.safeAreaInset(edge: .bottom) {
				if searchQuery.isEmpty {
					CategorySelectionView(selection: $category,
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
					if selection.isEmpty {
						ModalDismissButton(doneAction)
					} else {
						Button(action: doneAction) {
							Image(systemName: "checkmark")
						}
						.prominentButton()
						.tint(.blue)
						.disabled(selection.isEmpty)
					}
				}
			}
		}
		.symbolPickerLimit(limit)
		.onChange(of: selection) { oldValue, newValue in
			if singleMode, !newValue.isEmpty {
				doneAction()
			}
		}
	}
	
	func doneAction() -> Void {
		guard let onDone else {
			dismiss()
			return
		}
		onDone()
	}
}

#Preview {
	SymbolPickerScreen(symbols: .constant(["cat.fill", "dog.fill"]))
}
