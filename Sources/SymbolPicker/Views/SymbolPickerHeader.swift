//
//  Created by Emilio Peláez on 5/8/24.
//

import SwiftUI
import ToolKit
import UIToolKit

struct SymbolPickerHeader: View {
	@Environment(\.symbolPickerTitle) var symbolPickerTitle
	@Environment(\.symbolPickerLimit) var symbolPickerLimit
	
	@Binding var selection: [String]
	let onDone: () -> Void
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				symbolPickerTitle
					.extendHorizontally(alignment: .leading)
				Button("Done", action: onDone)
				.font(.headline)
			}
			.padding(.horizontal)
			ScrollView(.horizontal, showsIndicators: false) {
				if let symbolPickerLimit, symbolPickerLimit < 20 {
					HStack(alignment: .firstTextBaseline) {
						ForEach(0..<(symbolPickerLimit), id: \.self) { index in
							Image(systemName: "square.dotted")
								.opacity(selection[safe: index] == nil ? 0.25 : 0)
								.minSize {
									Image(systemName: "square.and.arrow.up")
										.paddingTiny()
								}
								.overlay {
									if let symbol = selection[safe: index] {
										button(symbol)
									}
								}
						}
					}
					.padding(.horizontal)
				} else {
					HStack(alignment: .firstTextBaseline) {
						ForEach(selection, id: \.self) { symbol in
							button(symbol)
						}
					}
					.minSize {
						Image(systemName: "square.and.arrow.up")
							.paddingTiny()
					}
					.padding(.horizontal)
				}
			}
			.font(.title3)
		}
	}
	
	func button(_ symbol: String) -> some View {
		Button {
			selection.remove(symbol)
		} label: {
			Image(systemName: symbol)
		}
		.buttonStyle(.plain)
	}
}

#Preview {
	SymbolPickerHeader(selection: .constant([]), onDone: {})
}
