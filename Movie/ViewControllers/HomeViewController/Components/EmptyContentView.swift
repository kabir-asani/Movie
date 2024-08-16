//
//  EmptyContentView.swift
//  Movie
//
//  Created by Kabir Asani on 16/08/24.
//

import UIKit

class EmptyContentView: UIView {
	private let containerStackView: UIStackView = UIStackView()
	private let imageView: UIImageView = UIImageView()
	private let titleLabel: UILabel = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configure() {
		configureSelf()
		configureContainerStackView()
		configureImageView()
		configureTitleLabel()
	}
	
	private func configureSelf() {
		// Do nothing
	}
	
	private func configureContainerStackView() {
		addSubview(containerStackView)
		
		containerStackView.pin(to: self)
		
		containerStackView.axis = .vertical
		containerStackView.spacing = 8.0
		containerStackView.distribution = .fill
		containerStackView.alignment = .center
		
		containerStackView.addArrangedSubview(imageView)
		containerStackView.addArrangedSubview(titleLabel)
	}
	
	private func configureImageView() {
		imageView.squareOff(withSide: 75)
		imageView.contentMode = .scaleAspectFit
		imageView.tintColor = .label
	}
	
	private func configureTitleLabel() {
		titleLabel.numberOfLines = 0
		titleLabel.font = .preferredFont(forTextStyle: .headline)
		titleLabel.textAlignment = .center
	}
}

extension EmptyContentView {
	func configure(
		withImage image: UIImage,
		title: String?
	) {
		imageView.image = image
		
		if let title {
			titleLabel.show()
			titleLabel.text = title
		} else {
			titleLabel.hide()
		}
	}
}
