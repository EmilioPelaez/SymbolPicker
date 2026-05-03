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
		if #available(iOS 26.0, *) {
			NavigationView {
				ScrollView {
					if let category {
						SymbolCategoryView(symbols: symbolLoader.symbols,
															 selection: $selection,
															 category: category,
															 loader: categoryLoader)
						.paddingMedium()
					} else if !searchQuery.isEmpty {
						SymbolSearchView(symbols: symbolLoader.symbols,
														 query: searchQuery,
														 selection: $selection)
						.paddingMedium()
					} else {
						ProgressView()
							.progressViewStyle(.circular)
					}
				}
				.safeAreaInset(edge: .bottom) {
					CategorySelectionView(selection: $category,
																categories: categoryLoader.categories)
					.glassEffect(.regular, in: .capsule)
					.paddingMedium(.horizontal)
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
						.buttonStyle(.glassProminent)
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
		} else {
			Text(":(")
		}
	}
}

#Preview {
	SymbolPickerScreen(symbols: .constant(["cat.fill", "dog.fill"]))
}
