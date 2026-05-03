//
//  Created by Emilio Peláez on 4/8/24.
//

import SwiftUI
import UIToolKit

struct SymbolList: View {
	@Environment(\.symbolPickerLimit) var symbolPickerLimit
	@ScaledMetric var minWidth: CGFloat = 40
	@ScaledMetric var maxWidth: CGFloat = 80
	
	let symbols: [String]
	@Binding var selection: [String]
	var processedSymbols: [String] {
		selection + symbols.filter { !selection.contains($0) }
	}
	
	var columns: [GridItem] {
		[.init(.adaptive(minimum: max(50, minWidth), maximum: maxWidth))]
	}
	
	var body: some View {
		LazyVGrid(columns: columns) {
			ForEach(processedSymbols, id: \.self) { symbol in
				Button {
					if selection.contains(symbol) {
						selection.remove(symbol)
					} else if selection.count < (symbolPickerLimit ?? .max) {
						selection.append(symbol)
					} else {
						print("Report Error")
					}
				} label: {
					SymbolView(symbol: symbol, isSelected: selection.contains(symbol))
						.font(.title)
				}
				.buttonStyle(.plain)
			}
		}
	}
}
