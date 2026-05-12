//
//  Created by Emilio Peláez on 4/8/24.
//

import SwiftUI
import UIToolKit

struct SymbolList: View {
	@Environment(\.symbolPickerLimit) var symbolPickerLimit
	@Environment(\.triggerEvent) var triggerEvent
	@ScaledMetric var minWidth: CGFloat = 40
	@ScaledMetric var maxWidth: CGFloat = 80
	@Namespace var symbolList

	let symbols: [String]
	let sectionTitle: String
	@Binding var selection: [String]
	@State var wiggleTriggers: [String: Int] = [:]
	var processedSymbols: [String] {
		symbols.filter { !selection.contains($0) }
	}

	var selectionLimit: Int {
		symbolPickerLimit ?? 1
	}

	var placeholders: Range<Int> {
		
		
		switch symbolPickerLimit {
		case .some(0): return (0..<0) // Should never happen since the view modifier clamps to (1, .max)
		case .none: return (0..<max(0, 1 - selection.count))
		case .some(let limit) where limit > 10: return (0..<max(0, 1 - selection.count))
		case .some(let limit): return (selection.count..<limit)
		}
	}

	var selectionHeader: String {
		if let limit = symbolPickerLimit {
			"Selection (\(selection.count)/\(limit))"
		} else {
			"Selection (\(selection.count))"
		}
	}

	var columns: [GridItem] {
		[.init(.adaptive(minimum: max(50, minWidth), maximum: maxWidth))]
	}

	var body: some View {
		LazyVGrid(columns: columns) {
			if symbolPickerLimit != 1 {
				Section {
					ForEach(selection, id: \.self) { symbol in
						button(for: symbol, isSelected: true)
							.id(symbol + "_selected")
					}
					ForEach(placeholders, id: \.self) { index in
						button(for: .emptySymbolSelectionSystemImage, isSelected: false)
							.id("placeholder_\(index)")
							.visiblyDisabled(true)
					}
				} header: {
					sectionHeader(selectionHeader)
				}
			}
			Section {
				ForEach(symbolPickerLimit == 1 ? symbols : processedSymbols, id: \.self) { symbol in
					button(for: symbol, isSelected: selection.contains(symbol))
						.id(symbol)
				}
			} header: {
				sectionHeader(sectionTitle)
			}
		}
	}

	func sectionHeader(_ title: String) -> some View {
		Text(title)
			.font(.headline)
			.frame(maxWidth: .infinity, alignment: .leading)
			.paddingSmall(.bottom)
			.paddingMedium(.top)
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
