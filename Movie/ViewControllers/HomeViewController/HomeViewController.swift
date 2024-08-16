//
//  HomeViewController.swift
//  Movie
//
//  Created by Kabir Asani on 16/08/24.
//

import UIKit

class HomeViewController: UIViewController {
	private var searchTask: Task<Void, Never>? = nil
	private var currentPageNumber: Int = 0
	private var maximumPageCount: Int = 0
	private var searchText: String = ""
	
	private let emptyContentView: EmptyContentView = EmptyContentView()
	private let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
	private let searchResultsCollectionView: UICollectionView = UICollectionView(
		frame: .zero,
		collectionViewLayout: {
			// ITEM
			let itemSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(0.5),
				heightDimension: .absolute(280.0)
			)
			let item = NSCollectionLayoutItem(
				layoutSize: itemSize
			)
			
			// GROUP
			let groupSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .estimated(300)
			)
			let group = NSCollectionLayoutGroup.horizontal(
				layoutSize: groupSize,
				subitems: [item]
			)
			group.interItemSpacing = .fixed(8.0)
			
			// SECTION
			let section = NSCollectionLayoutSection(
				group: group
			)
			section.interGroupSpacing = 16.0
			section.contentInsets = NSDirectionalEdgeInsets(
				top: 8.0,
				leading: 8.0,
				bottom: 8.0,
				trailing: 8.0
			)
			
			// LAYOUT
			let layout = UICollectionViewCompositionalLayout(section: section)
			
			return layout
		}()
	)
	private lazy var searchResultsCollectionViewDataSource: UICollectionViewDiffableDataSource<Int, SearchItemModel> = {
		return UICollectionViewDiffableDataSource(
			collectionView: searchResultsCollectionView
		) { collectionView, indexPath, searchItem in
			guard let searchItemCollectionViewCell = collectionView.dequeueReusableCell(
				withReuseIdentifier: SearchItemCollectionViewCell.reuseIdentifier,
				for: indexPath
			) as? SearchItemCollectionViewCell else {
				fatalError("Unable to dequeue UICollectionViewCell with identitifier: \(SearchItemCollectionViewCell.reuseIdentifier)")
			}
			
			searchItemCollectionViewCell.configure(with: searchItem)
			
			return searchItemCollectionViewCell
		}
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configure()
	}
	
	private func configure() {
		configureNavigationBar()
		configureView()
		configureSearchResultsCollectionView()
		configureActivityIndicatorView()
		configureEmptyContentView()
		
		displayAwaitingSearchContentView()
	}
	
	private func configureNavigationBar() {
		title = "Movie"
		definesPresentationContext = true
		navigationController?.navigationBar.isOpaque = true
		
		configureNavigationItem()
	}
	
	private func configureNavigationItem() {
		let searchController = UISearchController()
		searchController.searchResultsUpdater = self
		searchController.searchBar.delegate = self
		searchController.searchBar.placeholder = "Search Movies"
		
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
	}
	
	private func configureView() {
		view.backgroundColor = .systemBackground
	}
	
	private func configureEmptyContentView() {
		emptyContentView.addAsSubview(of: view)
		emptyContentView.align(toCenterOf: view)
	}
	
	private func configureActivityIndicatorView() {
		activityIndicatorView.addAsSubview(of: view)
		activityIndicatorView.align(toCenterOf: view)
	}
	
	private func configureSearchResultsCollectionView() {
		searchResultsCollectionView.addAsSubview(of: view)
		searchResultsCollectionView.pin(to: view)
		
		searchResultsCollectionView.register(
			SearchItemCollectionViewCell.self,
			forCellWithReuseIdentifier: SearchItemCollectionViewCell.reuseIdentifier
		)
		
		searchResultsCollectionView.dataSource = searchResultsCollectionViewDataSource
		searchResultsCollectionView.delegate = self
		
		searchResultsCollectionView.backgroundColor = .systemBackground
		searchResultsCollectionView.keyboardDismissMode = .onDrag
	}
}

extension HomeViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		searchText = searchController.searchBar.text ?? ""
	}
}

extension HomeViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		fetchInitialPage()
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		currentPageNumber = 0
		maximumPageCount = 0
		searchText = ""
		
		resetSearchResultsCollectionViewData() {
			[weak self] in
			guard let `self` = self else { return }
			
			displayAwaitingSearchContentView()
		}
	}
}

extension HomeViewController: UICollectionViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height)) {
			fetchSubsequentPage()
		}
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		didSelectItemAt indexPath: IndexPath
	) {
		collectionView.deselectItem(
			at: indexPath,
			animated: true
		)
		
		let item = searchResultsCollectionViewDataSource.snapshot().itemIdentifiers[indexPath.item]
		
		navigationController?.pushViewController(
			MovieViewController(movieId: item.id),
			animated: true
		)
	}
}

extension HomeViewController {
	private func displaySearchResultsCollectionView() {
		activityIndicatorView.hide()
		emptyContentView.hide()
		searchResultsCollectionView.show()
	}
	
	private func displayActivityIndicatorView() {
		searchResultsCollectionView.hide()
		emptyContentView.hide()
		activityIndicatorView.show()
		activityIndicatorView.startAnimating()
	}
	
	private func displayEmptySearchesContentView() {
		displayEmptyContentView(
			withImage: UIImage(systemName: "archivebox")!,
			title: "No result to show"
		)
	}
	
	private func displayErrorInSearchingContentView() {
		displayEmptyContentView(
			withImage: UIImage(systemName: "bandage")!,
			title: "Something went wrong"
		)
	}
	
	private func displayAwaitingSearchContentView() {
		displayEmptyContentView(
			withImage: UIImage(systemName: "magnifyingglass")!,
			title: "Search for any movies"
		)
	}
	
	private func displayEmptyContentView(
		withImage: UIImage,
		title: String
	) {
		searchResultsCollectionView.hide()
		activityIndicatorView.hide()
		activityIndicatorView.stopAnimating()
		emptyContentView.show()
		
		emptyContentView.configure(
			withImage: UIImage(systemName: "magnifyingglass")!,
			title: "Search for any movies"
		)
	}
}

extension HomeViewController {
	private func resetSearchResultsCollectionViewData(
		completion: (() -> Void)? = nil
	) {
		var snapshot = NSDiffableDataSourceSnapshot<Int, SearchItemModel>()
		snapshot.appendSections([0])
		snapshot.appendItems([])
		
		searchResultsCollectionViewDataSource.apply(snapshot) {
			completion?()
		}
	}
	
	private func createFreshSearchResultsCollectionViewData(
		from search: SearchModel,
		completion: (() -> Void)? = nil
	) {
		var snapshot = NSDiffableDataSourceSnapshot<Int, SearchItemModel>()
		snapshot.appendSections([0])
		snapshot.appendItems(search.results)
		
		searchResultsCollectionViewDataSource.apply(snapshot) {
			completion?()
		}
	}
	
	private func appendSearchResultsToCollectionViewData(
		from search: SearchModel,
		completion: (() -> Void)? = nil
	) {
		var snapshot = searchResultsCollectionViewDataSource.snapshot()
		snapshot.appendItems(snapshot.itemIdentifiers(inSection: 0) + search.results)
		
		searchResultsCollectionViewDataSource.apply(snapshot, animatingDifferences: false) {
			completion?()
		}
	}
}

extension HomeViewController {
	enum SearchResultsError: Error {
		case unknown
	}
	
	private func fetchInitialPage() {
		guard !searchText.isEmpty else { return }
		
		self.searchTask?.cancel()
		
		displayActivityIndicatorView()
		
		self.searchTask = Task {
			let result = await fetchSearchResults(
				forSearchText: searchText,
				fromPage: 1
			)
			
			switch result {
			case .success(let search):
				DispatchQueue.main.async {
					[weak self] in
					guard let `self` = self else { return }
					
					currentPageNumber = 1
					maximumPageCount = search.maximumNumberOfPages
					
					createFreshSearchResultsCollectionViewData(from: search) {
						[weak self] in
						guard let `self` = self else { return }
						
						displaySearchResultsCollectionView()
						
						searchResultsCollectionView.scrollToItem(
							at: .init(
								item: 0,
								section: 0
							),
							at: .top,
							animated: true
						)
					}
				}
			case .failure(_):
				DispatchQueue.main.async {
					[weak self] in
					guard let `self` = self else { return }
					
					displayErrorInSearchingContentView()
				}
			}
		}
	}
	
	private func fetchSubsequentPage() {
		guard !searchText.isEmpty && currentPageNumber < maximumPageCount else { return }
		
		self.searchTask?.cancel()
		
		self.searchTask = Task {
			let result = await fetchSearchResults(
				forSearchText: searchText,
				fromPage: currentPageNumber + 1
			)
			
			switch result {
			case .success(let search):
				DispatchQueue.main.async {
					[weak self] in
					guard let `self` = self else { return }
					
					currentPageNumber += 1
					appendSearchResultsToCollectionViewData(from: search)
				}
			case .failure(_):
				break
			}
		}
	}
	
	private func fetchSearchResults(
		forSearchText searchText: String,
		fromPage page: Int
	) async -> Result<SearchModel, SearchResultsError> {
		guard let omdbAPIKey = Bundle.main.infoDictionary?["OMDB_API_KEY"] else {
			return .failure(.unknown)
		}
		
		guard let url = URL(string: "https://www.omdbapi.com?apikey=\(omdbAPIKey)&s=\(searchText)&page=\(page)") else {
			return .failure(.unknown)
		}
		
		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			
			let decoder = JSONDecoder()
			
			let search = try decoder.decode(
				SearchModel.self,
				from: data
			)
			
			return .success(search)
		} catch {
			return .failure(.unknown)
		}
	}
}
