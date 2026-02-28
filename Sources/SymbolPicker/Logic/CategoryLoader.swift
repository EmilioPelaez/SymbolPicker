//
//  Created by Emilio Peláez on 5/8/24.
//

import Foundation
import ToolKit

class CategoryLoader: ObservableObject {
	@Published var categories: [SymbolCategory] = []
	@Published var symbolCategoryMap: [String: [String]] = [:]
	
	init() {
		do {
			categories = try loadCategories()
			symbolCategoryMap = try loadMap()
		} catch {
			print("Failed to load symbols")
		}
	}
	
	func symbol(_ symbol: String, in category: SymbolCategory) -> Bool {
		symbolCategoryMap[symbol]?.contains(category.key) ?? false
	}
	
	private func loadCategories() throws -> [SymbolCategory] {
		let bundle = Bundle.module
		let path = try bundle.url(forResource: "categories", withExtension: "plist").unwrap()
		let data = try Data(contentsOf: path)
		let values = try PropertyListDecoder().decode([SymbolCategory].self, from: data)
		return values
	}
	
	private func loadMap() throws -> [String: [String]] {
		let bundle = Bundle.module
		let path = try bundle.url(forResource: "symbol_categories", withExtension: "plist").unwrap()
		let data = try Data(contentsOf: path)
		let values = try PropertyListDecoder().decode([String: [String]].self, from: data)
		return values
	}
}
