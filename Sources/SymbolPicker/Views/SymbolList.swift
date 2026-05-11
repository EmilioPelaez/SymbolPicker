//
//  Created by Emilio Peláez on 4/8/24.
//

import SwiftUI
import UIToolKit

struct SymbolList: View {
	@Environment(\.symbolPickerLimit) var symbolPickerLimit
	@ScaledMetric var minWidth: CGFloat = 40
	@ScaledMetric var maxWidth: CGFloat = 80
	@Namespace var symbolList
	
	let symbols: [String]
	@Binding var selection: [String]
	@State var wiggleTriggers: [String: Int] = [:]
	var processedSymbols: [String] {
		symbols.filter { !selection.contains($0) }
	}
	var placeholderSymbols: [String] {
		selection.isEmpty ? [.emptySymbolSelectionSystemImage] : []
	}
	
	var columns: [GridItem] {
		[.init(.adaptive(minimum: max(50, minWidth), maximum: maxWidth))]
	}
	
	var body: some View {
		LazyVGrid(columns: columns) {
			Section {
				if selection.isEmpty {
					button(for: .emptySymbolSelectionSystemImage, isSelected: false)
						.id("placeholder")
						.visiblyDisabled(true)
				}
				ForEach(selection, id: \.self) { symbol in
					button(for: symbol, isSelected: true)
						.id(symbol + "_selected")
				}
			}
			Section {
				ForEach(processedSymbols, id: \.self) { symbol in
					button(for: symbol, isSelected: false)
						.id(symbol)
				}
			}
		}
	}
	
	func button(for symbol: String, isSelected: Bool) -> some View {
		Button {
			withAnimation(.easeInOut) {
				if selection.contains(symbol) {
					selection.remove(symbol)
				} else if selection.count < (symbolPickerLimit ?? .max) {
					selection.append(symbol)
				} else if symbolPickerLimit == 1 {
					selection = [symbol]
				} else {
					wiggleTriggers[symbol, default: 0] += 1
				}
			}
		} label: {
			SymbolView(symbol: symbol, isSelected: isSelected, wiggleTrigger: wiggleTriggers[symbol, default: 0])
				.font(.title)
				.contentShape(.rect)
		}
		.buttonStyle(.plain)
		.transition(.opacity)
	}
}
