//
//  CategoryList.swift
//  SymbolPicker
//
//  Created by Emilio Peláez on 7/5/26.
//

import SwiftUI

struct CategoryList: View {
	@Binding var selection: SymbolCategory?
	let categories: [SymbolCategory]

	var body: some View {
		Form {
			Picker("Category", selection: $selection) {
				ForEach(categories) { category in
					Label(category.key.capitalized, systemImage: category.icon)
				}
			}
			.pickerStyle(.inline)
		}
		.formStyle(.grouped)
	}
}

#Preview {
	CategoryList(selection: .constant(SymbolCategory(key: "a", icon: "dog")),
				 categories: [
					SymbolCategory(key: "a", icon: "dog"),
					SymbolCategory(key: "b", icon: "cat"),
				 ])
}
