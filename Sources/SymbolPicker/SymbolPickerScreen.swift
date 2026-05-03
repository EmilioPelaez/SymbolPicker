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
	
	@State var category: SymbolCategory?
	@State var searchQuery: String = ""
	//	TODO: Implement single symbol selection
	//	public init(symbol: Binding<String?>) {
	//
	//	}
	
	public init(symbols: Binding<[String]>, onDone: (() -> Void)? = nil) {
		self._selection = .init(projectedValue: symbols)
		self.onDone = onDone
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
	}
}

#Preview {
	SymbolPickerScreen(symbols: .constant(["cat.fill", "dog.fill"]))
}
