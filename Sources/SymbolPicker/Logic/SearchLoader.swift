//
//  SearchLoader.swift
//  SymbolPicker
//
//  Created by Emilio Peláez on 6/8/24.
//

import Foundation
import ToolKit

class SearchLoader: ObservableObject {
	@Published var queries: [String: String] = [:]
	
	init() {
		do {
			queries = try load()
		} catch {
			print("Failed to load symbols")
		}
	}
	
	func symbol(_ symbol: String, matches query: String) -> Bool {
		(symbol + queries[symbol, default: ""]).contains(query)
	}
	
	private func load() throws -> [String: String] {
		let bundle = Bundle.module
		let path = try bundle.url(forResource: "symbol_search", withExtension: "plist").unwrap()
		let data = try Data(contentsOf: path)
		let values = try PropertyListDecoder().decode([String: [String]].self, from: data)
		return values.mapValues { $0.joined(separator: " ") }
	}
}
