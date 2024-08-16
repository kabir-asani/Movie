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
	
	let imageView = UIImageView()
	let activityIndicatorView = UIActivityIndicatorView()
	
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
		configureActivityIndicatorView()
	}
	
	private func configureSelf() {
		backgroundColor = .secondarySystemFill
	}
	
	private func configureImageView() {
		addSubview(imageView)
		
		imageView.pin(to: self)
	}
	
	private func configureActivityIndicatorView() {
		addSubview(activityIndicatorView)
		
		activityIndicatorView.pin(to: self)
	}
	
	func configure(withURL url: URL) {
		if let cachedImage = Self.imageCache.object(forKey: url as NSURL) {
			self.imageView.image = cachedImage
			return
		}
		
		imageView.hide()
		activityIndicatorView.show()
		activityIndicatorView.startAnimating()
		
		URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
			guard let self = self else { return }
			
			DispatchQueue.main.async {
				self.activityIndicatorView.stopAnimating()
				self.activityIndicatorView.hide()
			}
			
			if error != nil {
				return
			}
			
			if let data = data, let image = UIImage(data: data) {
				Self.imageCache.setObject(
					image,
					forKey: url as NSURL
				)
				
				DispatchQueue.main.async {
					self.imageView.image = image
					self.imageView.show()
				}
			}
		}.resume()
	}
}
