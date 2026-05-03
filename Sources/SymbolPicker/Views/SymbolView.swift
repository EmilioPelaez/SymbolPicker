//
//  Created by Emilio Peláez on 4/8/24.
//

import SwiftUI
import UIToolKit

struct SymbolView: View {
	let symbol: String
	let isSelected: Bool
	
	@State var size: CGSize = .zero
	var side: CGFloat {
		size.width
	}
	
	var body: some View {
		ZStack {
			Color.clear
			if isSelected {
				RoundedRectangle(cornerRadius: ceil(side / 4))
					.fill(.tint)
			}
			Image(systemName: symbol)
				.paddingSmall()
				.if(isSelected) {
					$0.foregroundStyle(.white)
				} else: {
					$0.foregroundStyle(.primary)
				}
		}
		.storeSize(in: $size)
		.frame(height: side)
		.animation(.spring(duration: 0.3), value: isSelected)
	}
}

#Preview {
	VStack {
		SymbolView(symbol: "dog.fill", isSelected: false)
		SymbolView(symbol: "dog.fill", isSelected: true)
	}
}
