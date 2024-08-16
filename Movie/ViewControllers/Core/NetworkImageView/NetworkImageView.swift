//
//  NetworkImageView.swift
//  Movie
//
//  Created by Kabir Asani on 16/08/24.
//

import UIKit
import Silicon

class NetworkImageView: UIView {
	private static let imageCache = NSCache<NSURL, UIImage>()
	
	static func precache(imageWithURL url: URL) {
		URLSession.shared.dataTask(with: url) { data, response, error in
			if error != nil {
				return
			}
			
			if let data = data, let image = UIImage(data: data) {
				Self.imageCache.setObject(
					image,
					forKey: url as NSURL
				)
			}
		}.resume()
	}
	
	private var task: URLSessionTask? = nil
	
	let imageView = UIImageView()
	let placeholderImageView = UIImageView(
		image: UIImage(
			systemName: "movieclapper"
		)
	)
	
	init() {
		super.init(frame: .zero)
		
		configure()
	}
	
	required init?(
		coder: NSCoder
	) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configure() {
		configureSelf()
		configureImageView()
		configurePlaceholderImageView()
	}
	
	private func configureSelf() {
		backgroundColor = .secondarySystemFill
	}
	
	private func configureImageView() {
		imageView.addAsSubview(of: self)
		imageView.pin(to: self)
	}
	
	private func configurePlaceholderImageView() {
		placeholderImageView.addAsSubview(of: self)
		placeholderImageView.tintColor = .separator
		placeholderImageView.contentMode = .scaleAspectFit
		placeholderImageView.squareOff(withSide: 44.0)
		placeholderImageView.align(toCenterOf: self)
	}
	
	func configure(withURL url: URL) {
		task?.cancel()
		
		imageView.image = nil
		placeholderImageView.show()
		
		if let cachedImage = Self.imageCache.object(forKey: url as NSURL) {
			self.imageView.image = cachedImage
			self.imageView.show()
			self.placeholderImageView.hide()
			return
		}
		
		task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
			guard let self = self else { return }
			
			DispatchQueue.main.async { [weak self] in
				guard let `self` = self else { return }
				
				if error == nil, let data = data, let image = UIImage(data: data) {
					// Cache the image
					Self.imageCache.setObject(image, forKey: url as NSURL)
					
					// Only set the image if the task is still valid
					if self.task?.state == .completed {
						self.placeholderImageView.hide()
						self.imageView.image = image
						self.imageView.show()
					}
				} else {
					self.imageView.hide()
					self.placeholderImageView.show()
				}
			}
		}
		
		task?.resume()
	}
	
	func prepareForReuse() {
		task?.cancel()
		
		task = nil
		imageView.image = nil
		
		imageView.hide()
		placeholderImageView.show()
	}
}
