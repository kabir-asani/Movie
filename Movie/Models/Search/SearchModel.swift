//
//  SearchModel.swift
//  Movie
//
//  Created by Kabir Asani on 16/08/24.
//

import Foundation

struct SearchModel: Codable {
	let matches: [SearchModel]
	
	enum CodingKeys: String, CodingKey {
		case matches = "Search"
	}
}
