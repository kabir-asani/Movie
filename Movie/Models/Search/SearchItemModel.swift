//
//  SearchItemModel.swift
//  Movie
//
//  Created by Kabir Asani on 16/08/24.
//

import Foundation

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
