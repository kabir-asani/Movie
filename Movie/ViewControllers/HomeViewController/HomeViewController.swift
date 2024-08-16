//
//  HomeViewController.swift
//  Movie
//
//  Created by Kabir Asani on 16/08/24.
//

import UIKit

class HomeViewController: UIViewController {
	private let emptyContentView: EmptyContentView = EmptyContentView()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		configure()
    }
	
	private func configure() {
		configureNavigationBar()
		configureView()
		configureEmptyContentView()
	}
	
	private func configureNavigationBar() {
		title = "Movie"
		let searchViewController = SearchViewController()
		
		let searchController = UISearchController(searchResultsController: searchViewController)
		searchController.searchBar.delegate = searchViewController
		searchController.searchBar.placeholder = "Search Movies"
		
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		definesPresentationContext = true
	}
	
	private func configureView() {
		view.backgroundColor = .systemBackground
	}
	
	private func configureEmptyContentView() {
		view.addSubview(emptyContentView)
		
		emptyContentView.align(toCenterOf: view)
		emptyContentView.configure(
			withImage: UIImage(systemName: "magnifyingglass")!,
			title: "Search for any movies"
		)
	}
}

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
