//
//  SearchModel.swift
//  Movie
//
//  Created by Kabir Asani on 16/08/24.
//

import Foundation

struct SearchModel: Codable {
	let matches: [SearchItemModel]
	let numberOfPages: Int
	
	init(
		matches: [SearchItemModel],
		numberOfPages: Int
	) {
		self.matches = matches
		self.numberOfPages = numberOfPages
	}
	
	init(
		from decoder: Decoder
	) throws {
		let container = try decoder.container(
			keyedBy: CodingKeys.self
		)
		self.matches = try container.decode(
			[SearchItemModel].self, 
			forKey: .matches
		)
		
		let totalResults = try container.decode(
			String.self,
			forKey: .numberOfPages
		)
		
		if let numberOfPages = Int(totalResults) {
			self.numberOfPages = numberOfPages
		} else {
			throw DecodingError.dataCorruptedError(
				forKey: .numberOfPages, 
				in: container, 
				debugDescription: "`totalResults` should be an Int."
			)
		}
	}
	
	enum CodingKeys: String, CodingKey {
		case matches = "Search"
		case numberOfPages = "totalResults"
	}
}

struct SearchItemModel: Identifiable, Codable {
	let id: String
	let title: String
	let poster: URL
	
	enum CodingKeys: String, CodingKey {
		case id = "imdbID"
		case title = "Title"
		case poster = "Poster"
	}
}
