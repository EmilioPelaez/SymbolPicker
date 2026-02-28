//
//  Created by Emilio Peláez on 5/8/24.
//

struct SymbolCategory: Identifiable, Hashable, Equatable, Decodable {
	var id: String { key }
	let key: String
	let icon: String
}
