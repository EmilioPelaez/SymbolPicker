//
//  Created by Emilio Peláez on 4/8/24.
//

import SwiftUI
import UIToolKit

struct SymbolPickerScreen: View {
	let symbols: [String]
	let category: SymbolCategory?
	let searchQuery: String
	let categoryLoader: CategoryLoader

	@Binding var selection: [String]

	var body: some View {
		ScrollViewReader { reader in
			ScrollView {
				Color.clear.frame(height: 0).id("Top")
				if !searchQuery.isEmpty {
					SymbolSearchView(symbols: symbols,
													 query: searchQuery,
													 selection: $selection)
					.paddingMedium()
				} else if let category {
					SymbolCategoryView(symbols: symbols,
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
				reader.scrollTo("Top")
			}
		}
	}
}

#Preview {
	SymbolPickerScreen(symbols: [],
					   category: nil,
					   searchQuery: "",
					   categoryLoader: CategoryLoader(),
					   selection: .constant(["cat.fill", "dog.fill"]))
}
