//
//  ContentView.swift
//  Example
//
//  Created by Emilio Peláez on 28/2/26.
//

import SwiftUI
import SymbolPicker

struct ContentView: View {
	@State var symbols: [String] = []
	
	var body: some View {
		Form {
			SymbolPicker("Select Symbols", selection: $symbols)
				.symbolPickerLimit(10)
		}
	}
}

#Preview {
	ContentView()
}
