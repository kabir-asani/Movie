//
//  SearchItemCollectionViewCell.swift
//  Movie
//
//  Created by Kabir Asani on 16/08/24.
//

import UIKit

class SearchItemCollectionViewCell: UICollectionViewCell {
	static var reuseIdentifier: String {
		String(describing: Self.self)
	}
	
	private let posterImageView: NetworkImageView = NetworkImageView()
	private let gradientView: UIView = UIView()
	private let titleLabel: UILabel = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configure() {
		configureContentView()
		configurePosterImageView()
		configureGradientView()
		configureTitleLabel()
	}
	
	private func configureContentView() {
		contentView.clipsToBounds = true
		contentView.layer.cornerRadius = 8.0
		contentView.layer.borderWidth = 2.0
		contentView.layer.borderColor = UIColor.separator.cgColor
	}
	
	private func configurePosterImageView() {
		posterImageView.clipsToBounds = true
		posterImageView.imageView.contentMode = .scaleAspectFill
		
		posterImageView.addAsSubview(of: contentView)
		posterImageView.pin(to: contentView)
	}
	
	private func configureGradientView() {
		gradientView.addAsSubview(of: contentView)
		gradientView.pin(
			to: contentView,
			withInsets: .init(
				top: 40,
				left: 0,
				bottom: 0,
				right: 0
			)
		)
		gradientView.backgroundColor = .clear
		
		let gradientLayer = CAGradientLayer()
		gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
		gradientLayer.locations = [0.0, 1.0]
		gradientLayer.frame = contentView.bounds
		gradientView.layer.addSublayer(gradientLayer)
	}
	
	private func configureTitleLabel() {
		titleLabel.addAsSubview(of: contentView)
		titleLabel.pin(toLeftOf: contentView, withInset: 12)
		titleLabel.pin(toRightOf: contentView, withInset: -12)
		titleLabel.pin(toBottomOf: contentView, withInset: -12)
		
		titleLabel.numberOfLines = 0
		titleLabel.lineBreakMode = .byTruncatingTail
		titleLabel.textColor = .white
		titleLabel.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize, weight: .semibold)
	}
}

extension SearchItemCollectionViewCell {
	func configure(with searchItem: SearchItemModel) {
		posterImageView.configure(withURL: searchItem.poster)
		titleLabel.text = searchItem.title
	}
	
	override func prepareForReuse() {
		posterImageView.prepareForReuse()
		titleLabel.text = nil
	}
}
