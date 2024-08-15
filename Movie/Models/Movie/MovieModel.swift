//
//  MovieModel.swift
//  Movie
//
//  Created by Kabir Asani on 16/08/24.
//

import Foundation

struct MovieModel: Identifiable, Codable {
	let id: String
	let title: String
	let releaseDate: Date
	let director: String
	let poster: URL
	let plot: String
	
	enum CodingKeys: String, CodingKey {
		case id = "imdbID"
		case title = "Title"
		case releaseDate = "Released"
		case director = "Director"
		case poster = "Poster"
		case plot = "Plot"
	}
}
