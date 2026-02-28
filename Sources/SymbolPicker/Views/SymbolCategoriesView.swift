//
//  Created by Emilio Peláez on 4/8/24.
//

import SwiftUI

struct SymbolCategoriesView: View {
	@Environment(\.ignoredSymbolCategories) var ignoredSymbolCategories
	@StateObject var loader = CategoryLoader()
	
	let symbols: [String]
	@Binding var selection: [String]
	@State var category: SymbolCategory?
	
	var categories: [SymbolCategory] {
		loader.categories.filter { !ignoredSymbolCategories.contains($0.key) }
	}
	
	var body: some View {
		VStack(spacing: 0) {
			TabView(selection: $category) {
				ForEach(categories) { category in
					SymbolCategoryView(symbols: symbols, selection: $selection, category: category, loader: loader)
						.tag(category)
				}
			}
#if !os(macOS)
			.tabViewStyle(.page(indexDisplayMode: .never))
#endif
			Divider()
			CategorySelectionView(selection: $category,
														categories: categories)
		}
		.onAppear {
			category = loader.categories.first
		}
	}
}

#Preview {
	SymbolCategoriesView(symbols: [], selection: .constant([]))
}
