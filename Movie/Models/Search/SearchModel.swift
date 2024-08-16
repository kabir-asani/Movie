//
//  SearchModel.swift
//  Movie
//
//  Created by Kabir Asani on 16/08/24.
//

import Foundation

struct SearchModel: Codable {
	let items: [SearchItemModel]
	let count: Int
	
	var maximumNumberOfPages: Int {
		Int(ceil(Double(count) / 10.0))
	}
	
	init(
		items: [SearchItemModel],
		count: Int
	) {
		self.items = items
		self.count = count
	}
	
	init(
		from decoder: Decoder
	) throws {
		let container = try decoder.container(
			keyedBy: CodingKeys.self
		)
		self.items = try container.decode(
			[SearchItemModel].self, 
			forKey: .items
		)
		
		let totalResults = try container.decode(
			String.self,
			forKey: .count
		)
		
		if let count = Int(totalResults) {
			self.count = count
		} else {
			throw DecodingError.dataCorruptedError(
				forKey: .count, 
				in: container, 
				debugDescription: "`totalResults` should be an Int."
			)
		}
	}
	
	enum CodingKeys: String, CodingKey {
		case items = "Search"
		case count = "totalResults"
	}
}

struct SearchItemModel: Identifiable, Hashable, Codable {
	let id: String
	let title: String
	let poster: URL
	
	enum CodingKeys: String, CodingKey {
		case id = "imdbID"
		case title = "Title"
		case poster = "Poster"
	}
}
