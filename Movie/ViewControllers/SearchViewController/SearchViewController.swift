//
//  SearchViewController.swift
//  Movie
//
//  Created by Kabir Asani on 16/08/24.
//

import UIKit


class SearchViewController: UIViewController {
	let items: [SearchItemModel] = [
		SearchItemModel(
			id: "tt2322441",
			title: "Fifty Shades of Grey",
			poster: URL(string: "https://m.media-amazon.com/images/M/MV5BMjE1MTM4NDAzOF5BMl5BanBnXkFtZTgwNTMwNjI0MzE@._V1_SX300.jpg")!
		),
		SearchItemModel(
			id: "tt4465564",
			title: "Fifty Shades Darker",
			poster: URL(string: "https://m.media-amazon.com/images/M/MV5BMTQ5NTk0Njg2N15BMl5BanBnXkFtZTgwNzk5Nzk3MDI@._V1_SX300.jpg")!
		),
		SearchItemModel(
			id: "tt4477536",
			title: "Fifty Shades Freed",
			poster: URL(string: "https://m.media-amazon.com/images/M/MV5BMTYxOTQ1MzI0Nl5BMl5BanBnXkFtZTgwMzgwMzIxNDM@._V1_SX300.jpg")!
		),
		SearchItemModel(
			id: "tt4667094",
			title: "Fifty Shades of Black",
			poster: URL(string: "https://m.media-amazon.com/images/M/MV5BMTQ3MTg3MzY4OV5BMl5BanBnXkFtZTgwNTI4MzM1NzE@._V1_SX300.jpg")!
		),
		SearchItemModel(
			id: "tt1097643",
			title: "Fifty Dead Men Walking",
			poster: URL(string: "https://m.media-amazon.com/images/M/MV5BNDFlZGQ4MDItMTU1Yi00N2IxLWJmNDgtNzg5YTQ3YTIyNTc5XkEyXkFqcGdeQXVyMTY3NzMzMjI2._V1_SX300.jpg")!
		),
		SearchItemModel(
			id: "tt0426462",
			title: "Fifty Pills",
			poster: URL(string: "https://m.media-amazon.com/images/M/MV5BM2ZmYTcwNGItMjlmMC00YzI3LTk1MmEtOTAwZmZmNjY3YzE0XkEyXkFqcGdeQXVyMTY5Nzc4MDY@._V1_SX300.jpg")!
		),
		SearchItemModel(
			id: "tt0303336",
			title: "Fifty Percent Grey",
			poster: URL(string: "https://m.media-amazon.com/images/M/MV5BYTI5ZjIyZmEtNTg2Yy00OTUyLTllMGMtZDNjOWU2NWE4NjVmXkEyXkFqcGdeQXVyMzU3MDU3NjI@._V1_SX300.jpg")!
		),
		SearchItemModel(
			id: "tt0106902",
			title: "Fifty/Fifty",
			poster: URL(string: "https://m.media-amazon.com/images/M/MV5BMmYwYTFkMzEtNDA3Yy00ZmY4LWIwNzMtM2EyZTY3YWIxNjI3XkEyXkFqcGdeQXVyMjY3MjUzNDk@._V1_SX300.jpg")!
		),
		SearchItemModel(
			id: "tt2134077",
			title: "It Was Fifty Years Ago Today! The Beatles: Sgt. Pepper & Beyond",
			poster: URL(string: "https://m.media-amazon.com/images/M/MV5BMTJjYWI5NTgtNTk2Yy00NTYyLWEwZWEtMDVlNmVjNzU0MGNiXkEyXkFqcGdeQXVyMjM0NjQyNTQ@._V1_SX300.jpg")!
		),
		SearchItemModel(
			id: "tt0175997",
			title: "Out in Fifty",
			poster: URL(string: "https://m.media-amazon.com/images/M/MV5BMTYzMzY3MTgzM15BMl5BanBnXkFtZTcwNzgzODQyMQ@@._V1_SX300.jpg")!
		)
	]
	
	private let searchResultsCollectionView: UICollectionView = UICollectionView(
		frame: .zero,
		collectionViewLayout: {
			// ITEM
			let itemSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(0.5),
				heightDimension: .estimated(250)
			)
			let item = NSCollectionLayoutItem(
				layoutSize: itemSize
			)
			item.contentInsets = NSDirectionalEdgeInsets(
				top: 10,
				leading: 10,
				bottom: 10,
				trailing: 10
			)

			// GROUP
			let groupSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .estimated(250)
			)
			let group = NSCollectionLayoutGroup.horizontal(
				layoutSize: groupSize,
				subitems: [item]
			)
				
			// SECTION
			let section = NSCollectionLayoutSection(
				group: group
			)
			section.interGroupSpacing = 16.0

			// LAYOUT
			let layout = UICollectionViewCompositionalLayout(section: section)
			
			return layout
		}()
	)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configure()
	}
	
	private func configure() {
		configureView()
		configureSearchResultsCollectionView()
	}
	
	private func configureView() {
		view.backgroundColor = .systemBackground
	}
	
	private func configureSearchResultsCollectionView() {
		view.addSubview(searchResultsCollectionView)
		
		searchResultsCollectionView.pin(
			to: view,
			byBeingSafeAreaAware: true
		)
		
		searchResultsCollectionView.dataSource = self
		searchResultsCollectionView.delegate = self
		
		searchResultsCollectionView.backgroundColor = .systemBackground
		searchResultsCollectionView.keyboardDismissMode = .onDrag
		searchResultsCollectionView.register(
			SearchItemCollectionViewCell.self,
			forCellWithReuseIdentifier: SearchItemCollectionViewCell.reuseIdentifier
		)
	}
}

extension SearchViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		
	}
}

extension SearchViewController: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		items.count
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		guard let searchItemCollectionViewCell = collectionView.dequeueReusableCell(
			withReuseIdentifier: SearchItemCollectionViewCell.reuseIdentifier,
			for: indexPath
		) as? SearchItemCollectionViewCell else {
			fatalError("Unable to dequeu cell with identifier: \(SearchItemCollectionViewCell.reuseIdentifier)")
		}
		
		let item = items[indexPath.row]
		
		searchItemCollectionViewCell.configure(
			with: item
		)
		
		return searchItemCollectionViewCell
	}
}

extension SearchViewController: UICollectionViewDelegate {
	func collectionView(
		_ collectionView: UICollectionView,
		willDisplay cell: UICollectionViewCell,
		forItemAt indexPath: IndexPath
	) {
		let item = items[indexPath.row]
		
		NetworkImageView.precache(imageWithURL: item.poster)
	}
}

