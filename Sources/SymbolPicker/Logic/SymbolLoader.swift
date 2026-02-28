//
//  Created by Emilio Peláez on 4/8/24.
//

import Foundation
import ToolKit

class SymbolLoader: ObservableObject {
	@Published var symbols: [String] = []
	
		init() {
			do {
				symbols = try load()
			} catch {
				print("Failed to load symbols")
			}
		}
	
	func load() throws -> [String] {
		let bundle = Bundle.module
		let path = try bundle.url(forResource: "symbol_order", withExtension: "plist").unwrap()
		let data = try Data(contentsOf: path)
		let values = try PropertyListDecoder().decode([String].self, from: data)
		return values
	}
}
