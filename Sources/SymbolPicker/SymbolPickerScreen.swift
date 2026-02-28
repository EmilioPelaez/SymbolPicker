//
//  Created by Emilio Peláez on 4/8/24.
//

import SwiftUI

public struct SymbolPickerScreen: View {
	@Environment(\.dismiss) var dismiss
	@StateObject var loader = SymbolLoader()
	
	@Binding var selection: [String]
	let onDone: (() -> Void)?
	
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
		VStack(alignment: .leading, spacing: 0) {
			SymbolPickerHeader(selection: $selection,
												 onDone: onDone ?? { dismiss() })
			.padding(.top)
			SearchBar(query: $searchQuery)
				.padding()
			Divider()
			Group {
				if searchQuery.isEmpty {
					SymbolCategoriesView(symbols: loader.symbols, selection: $selection)
				} else {
					SymbolSearchView(symbols: loader.symbols,
													 query: searchQuery,
													 selection: $selection)
				}
			}
			.frame(minHeight: 300, idealHeight: 600)
		}
		.ignoresSafeArea(.keyboard, edges: .all)
	}
}

#Preview {
	SymbolPickerScreen(symbols: .constant(["cat.fill", "dog.fill"]))
}
