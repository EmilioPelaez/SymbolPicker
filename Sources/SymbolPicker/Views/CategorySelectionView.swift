//
//  Created by Emilio Peláez on 5/8/24.
//

import SwiftUI
import UIToolKit

struct CategorySelectionView: View {
	@Binding var selection: SymbolCategory?
	let categories: [SymbolCategory]
	
	var body: some View {
		ScrollViewReader { proxy in
			ScrollView(.horizontal) {
				HStack(spacing: 0) {
					ForEach(categories) { category in
						Button {
							selection = category
						} label: {
							Image(systemName: category.icon)
								.paddingSmall()
						}
						.font(.title2)
						.contentShape(Rectangle())
						.buttonStyle(.plain)
						.if(category == selection) {
							$0
								.foregroundStyle(.tint)
								.symbolVariant(.fill)
						} else: {
							$0
						}
						.id(category)
					}
				}
				.paddingMedium(.horizontal)
				.paddingSmall(.vertical)
				.onChange(of: selection) {
					guard let selection else { return }
					withAnimation {
						proxy.scrollTo(selection, anchor: .center)
					}
				}
			}
		}
	}
}

#Preview {
	CategorySelectionView(selection: .constant(SymbolCategory(key: "a", icon: "dog")),
												categories: [
													SymbolCategory(key: "a", icon: "dog"),
													SymbolCategory(key: "b", icon: "cat"),
												])
}
