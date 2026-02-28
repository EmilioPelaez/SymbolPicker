//
//  Created by Emilio Peláez on 6/8/24.
//

import SwiftUI

struct SearchBar: View {
	@Binding var query: String
	@FocusState var focused: Bool
	
	var body: some View {
		HStack(alignment: .firstTextBaseline) {
			Image(systemName: "magnifyingglass")
			TextField("Search", text: $query)
				.extendHorizontally(alignment: .leading)
				.focused($focused)
				.autocorrectionDisabled()
//				.textInputAutocapitalization(.never)
			if !query.isEmpty {
				Button {
					query = ""
				} label: {
					Image(systemName: "xmark.circle.fill")
				}
				.foregroundStyle(.secondary)
			}
		}
		.paddingMedium(.horizontal)
		.paddingMedium(.vertical)
		.background {
			RoundedRectangle(cornerRadius: .paddingMedium)
				.fill(.quaternary)
				.opacity(0.5)
		}
		.onTapGesture {
			focused = true
		}
	}
}

#Preview {
	SearchBar(query: .constant(""))
}
