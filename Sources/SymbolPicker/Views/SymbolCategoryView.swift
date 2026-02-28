//
//  Created by Emilio Peláez on 6/8/24.
//

import SwiftUI

struct SymbolCategoryView: View {
	let symbols: [String]
	@Binding var selection: [String]
	
	init(symbols: [String], selection: Binding<[String]>, category: SymbolCategory, loader: CategoryLoader) {
		if category.key == "all" {
			self.symbols = symbols
		} else {
			self.symbols = symbols.filter { loader.symbol($0, in: category) }
		}
		_selection = .init(projectedValue: selection)
	}
	
	var body: some View {
		SymbolList(symbols: symbols, selection: $selection)
	}
}
