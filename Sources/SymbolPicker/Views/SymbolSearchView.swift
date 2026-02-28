//
//  Created by Emilio Peláez on 4/8/24.
//

import SwiftUI

struct SymbolSearchView: View {
	@StateObject var loader = SearchLoader()
	
	let symbols: [String]
	let query: String
	@Binding var selection: [String]
	
	var filteredSymbols: [String] {
		symbols.filter { loader.symbol($0, matches: query.lowercased()) }
	}
	
	var body: some View {
		SymbolList(symbols: filteredSymbols, selection: $selection)
	}
}
