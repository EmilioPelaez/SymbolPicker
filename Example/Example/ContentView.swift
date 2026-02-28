//
//  ContentView.swift
//  Example
//
//  Created by Emilio Peláez on 28/2/26.
//

import SwiftUI
import SymbolPicker

struct ContentView: View {
    var body: some View {
			Form {
				SymbolPicker(title: "Select Symbol", symbol: "pencil.circle.fill")
			}
    }
}

#Preview {
    ContentView()
}
