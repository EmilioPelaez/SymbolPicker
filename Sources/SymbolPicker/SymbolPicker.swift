//
//  SymbolPicker.swift
//  SymbolPicker
//
//  Created by Emilio Peláez on 28/2/26.
//

import SwiftUI

public struct SymbolPicker: View {
	let title: String
	let symbol: String
	
	public init(title: String, symbol: String) {
		self.title = title
		self.symbol = symbol
	}
	
	public var body: some View {
		Button {
			print("Show symbol picker")
		}
		label: {
			LabeledContent(title) {
				Image(systemName: symbol)
			}
		}
	}
}
