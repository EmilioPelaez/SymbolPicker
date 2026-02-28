//
//  Created by Emilio Peláez on 5/8/24.
//

import CGMath
import SwiftUI

public extension View {
	func symbolPickerLimit(_ limit: Int?) -> some View {
		environment(\.symbolPickerLimit, limit?.clamped(min: 1, max: .max))
	}
	
	func ignoredSymbolCategories(_ categories: [String]) -> some View {
		environment(\.ignoredSymbolCategories, categories)
	}
	
	func symbolPickerTitle(_ title: Text) -> some View {
		environment(\.symbolPickerTitle, title)
	}
}

extension EnvironmentValues {
	@Entry var symbolPickerLimit: Int? = 5
	@Entry var ignoredSymbolCategories = ["whatsnew", "multicolor", "variablecolor"]
	@Entry var symbolPickerTitle: Text = .init("Select Icons").font(.title3)
}
