//
//  Created by Emilio Peláez on 6/8/24.
//

import SwiftUI

struct SymbolCategoryView: View {
	let symbols: [String]
	let sectionTitle: String
	@Binding var selection: [String]

	init(symbols: [String], selection: Binding<[String]>, category: SymbolCategory?, loader: CategoryLoader) {
		func filter(_ symbols: [String], in category: SymbolCategory?) -> [String] {
			guard let category, category.key != "all" else {
				return symbols
			}
			return symbols.filter { loader.symbol($0, in: category) }
		}
		self.symbols = filter(symbols, in: category)
		self.sectionTitle = category.flatMap { $0.key != "all" ? $0.key.capitalized : nil } ?? "All Symbols"
		_selection = .init(projectedValue: selection)
	}

	var body: some View {
		SymbolList(symbols: symbols, sectionTitle: sectionTitle, selection: $selection)
	}
}
