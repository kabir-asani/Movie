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
	let releaseDate: Date?
	let director: String
	let poster: URL
	let plot: String
	
	init(
		id: String,
		title: String,
		releaseDate: Date?,
		director: String,
		poster: URL,
		plot: String
	) {
		self.id = id
		self.title = title
		self.releaseDate = releaseDate
		self.director = director
		self.poster = poster
		self.plot = plot
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		id = try container.decode(String.self, forKey: .id)
		title = try container.decode(String.self, forKey: .title)
		director = try container.decode(String.self, forKey: .director)
		poster = try container.decode(URL.self, forKey: .poster)
		plot = try container.decode(String.self, forKey: .plot)
		
		let releaseDateString = try container.decode(String.self, forKey: .releaseDate)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd MMM yyyy"
		releaseDate = dateFormatter.date(from: releaseDateString)
	}
	
	enum CodingKeys: String, CodingKey {
		case id = "imdbID"
		case title = "Title"
		case releaseDate = "Released"
		case director = "Director"
		case poster = "Poster"
		case plot = "Plot"
	}
}
