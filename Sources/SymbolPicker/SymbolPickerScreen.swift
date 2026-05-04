//
//  Created by Emilio Peláez on 4/8/24.
//

import SwiftUI
import UIToolKit

public struct SymbolPickerScreen: View {
	@Environment(\.dismiss) var dismiss
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
	
	public var body: some View {
		
		NavigationView {
			ScrollView {
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
			.navigationTitle("Select Symbols")
			.navigationBarTitleDisplayMode(.inline)
			.searchable(text: $searchQuery)
			.safeAreaInset(edge: .bottom) {
				if searchQuery.isEmpty {
					CategorySelectionView(selection: $category,
																categories: categoryLoader.categories)
					.floatingBackground()
					.paddingMedium(.horizontal)
					.transition(.opacity)
					.animation(.linear, value: searchQuery.isEmpty)
				}
			}
			.frame(minHeight: 300, idealHeight: 600)
			.onAppear {
				category = categoryLoader.categories.first
			}
			.toolbar {
				ToolbarItem(placement: .confirmationAction) {
					Button(action: onDone ?? dismiss.callAsFunction) {
						Image(systemName: "checkmark")
					}
					.prominentButton()
					.tint(.blue)
					.disabled(selection.isEmpty)
				}
			}
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					ModalDismissButton(dismiss)
				}
			}
		}
		.if(singleMode) { $0.symbolPickerLimit(1) }
		.onChange(of: selection) {
			if singleMode, !selection.isEmpty {
				onDone?()
			}
		}
	}
}

#Preview {
	SymbolPickerScreen(symbols: .constant(["cat.fill", "dog.fill"]))
}
