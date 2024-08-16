//
//  MovieTableViewCell.swift
//  Movie
//
//  Created by Kabir Asani on 16/08/24.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
	static var reuseIdentifier: String {
		String(describing: Self.self)
	}
	
	private let containerStackView: UIStackView = UIStackView()
	private let posterImageView: NetworkImageView = NetworkImageView()
	private let titleLabel: UILabel = UILabel()
	private let subtitleLabel: UILabel = UILabel()
	private let separatorView: UIView = UIView()
	private let plotLabel: UILabel = UILabel()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configure() {
		configureContentView()
		configureContainerStackView()
		configurePosterImageView()
		configureTitleLabel()
		configureSubtitleLabel()
		configureSeparatorView()
		configurePlotLabel()
	}
	
	private func configureContentView() {
		
	}
	
	private func configureContainerStackView() {
		containerStackView.addAsSubview(of: contentView)
		containerStackView.pin(
			to: contentView,
			withInsets: .init(
				top: 12,
				left: 12,
				bottom: -12,
				right: -12
			)
		)
		
		containerStackView.axis = .vertical
		containerStackView.alignment = .center
		containerStackView.distribution = .fill
		
		containerStackView.addArrangedSubview(posterImageView)
		containerStackView.addArrangedSubview(titleLabel)
		containerStackView.addArrangedSubview(subtitleLabel)
		containerStackView.addArrangedSubview(separatorView)
		containerStackView.addArrangedSubview(plotLabel)
		
		containerStackView.setCustomSpacing(12.0, after: posterImageView)
		containerStackView.setCustomSpacing(4.0, after: titleLabel)
		containerStackView.setCustomSpacing(16.0, after: subtitleLabel)
		containerStackView.setCustomSpacing(16.0, after: separatorView)
	}
	
	private func configurePosterImageView() {
		posterImageView.fixHeight(to: 240)
		posterImageView.fixWidth(to: 150)
		
		posterImageView.imageView.contentMode = .scaleAspectFill
		posterImageView.clipsToBounds = true
		posterImageView.layer.cornerRadius = 8.0
		posterImageView.layer.borderWidth = 1.0
		posterImageView.layer.borderColor = UIColor.separator.cgColor
	}
	
	private func configureTitleLabel() {
		titleLabel.numberOfLines = 0
		titleLabel.textAlignment = .center
		titleLabel.font = .systemFont(
			ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize,
			weight: .bold
		)
	}
	
	private func configureSubtitleLabel() {
		subtitleLabel.numberOfLines = 0
		subtitleLabel.textAlignment = .center
		subtitleLabel.font = .systemFont(
			ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize,
			weight: .medium
		)
		subtitleLabel.textColor = .secondaryLabel
	}
	
	private func configureSeparatorView() {
		separatorView.fixHeight(to: 1.0)
		separatorView.fixWidth(to: 64.0)
		
		separatorView.backgroundColor = .separator
	}
	
	private func configurePlotLabel() {
		plotLabel.numberOfLines = 0
		plotLabel.textAlignment = .center
		plotLabel.font = .systemFont(
			ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize,
			weight: .regular
		)
	}
}

extension MovieTableViewCell {
	func configure(withMovie movie: MovieModel) {
		posterImageView.configure(withURL: movie.poster)
		titleLabel.text = movie.title
		subtitleLabel.text = "Directed by \(movie.director) • Released on \(movie.releaseDate)"
		plotLabel.text = movie.plot
	}
	
	override func prepareForReuse() {
		posterImageView.prepareForReuse()
		titleLabel.text = nil
		subtitleLabel.text = nil
		plotLabel.text = nil
	}
}
