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
	private let titleContainerEffectView: UIVisualEffectView = UIVisualEffectView()
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
		configureTitleContainerEffectView()
		configureTitleLabel()
	}
	
	private func configureContentView() {
		contentView.clipsToBounds = true
		contentView.layer.cornerRadius = 8.0
		contentView.layer.cornerRadius = 8.0
		contentView.layer.borderWidth = 1.0
		contentView.layer.borderColor = UIColor.separator.cgColor
	}
	
	private func configurePosterImageView() {
		contentView.addSubview(posterImageView)
		posterImageView.pin(to: contentView)
		posterImageView.clipsToBounds = true
		posterImageView.imageView.contentMode = .scaleAspectFill
	}
	
	private func configureTitleContainerEffectView() {
		contentView.addSubview(titleContainerEffectView)
		titleContainerEffectView.pin(toLeftOf: contentView)
		titleContainerEffectView.pin(toRightOf: contentView)
		titleContainerEffectView.pin(toBottomOf: contentView)
		
		titleContainerEffectView.clipsToBounds = true
		titleContainerEffectView.effect = UIBlurEffect(style: .systemThinMaterial)
	}
	
	private func configureTitleLabel() {
		titleContainerEffectView.contentView.addSubview(titleLabel)
		titleLabel.pin(
			to: titleContainerEffectView.contentView,
			withInsets: .init(
				top: 8.0,
				left: 8.0,
				bottom: -8.0,
				right: -8.0
			)
		)
		
		titleLabel.numberOfLines = 1
		titleLabel.lineBreakMode = .byTruncatingTail
		titleLabel.font = .preferredFont(forTextStyle: .subheadline)
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
