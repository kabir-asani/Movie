//
//  DateX.swift
//  Movie
//
//  Created by Kabir Asani on 16/08/24.
//

import Foundation

extension Date {
	var monthYear: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM yyyy"
		return dateFormatter.string(from: self)
	}
}
