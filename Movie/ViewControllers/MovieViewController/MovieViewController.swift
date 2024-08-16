//
//  MovieViewController.swift
//  Movie
//
//  Created by Kabir Asani on 16/08/24.
//

import UIKit
import Silicon

enum MovieViewState {
	case undetermined
	case data(movie: MovieModel)
	case error
}

class MovieViewController: UIViewController {
	private let movieId: String
	
	private var state: MovieViewState = .undetermined {
		didSet {
			configureAppearancesOfEachViewAsPerState()
		}
	}
	
	private let tableView: UITableView = UITableView()
	private let errorContentView: EmptyContentView = EmptyContentView()
	private let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
	
	init(movieId: String) {
		self.movieId = movieId
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configure()
		
		Task {
			await fetchMovie()
		}
	}
	
	private func configure() {
		configureNavigationBar()
		
		configureView()
		configureTableView()
		configureErrorContentView()
		configureActivityIndicatorView()
		
		configureAppearancesOfEachViewAsPerState()
	}
	
	private func configureNavigationBar() {
		navigationItem.largeTitleDisplayMode = .never
	}
	
	private func configureView() {
		view.backgroundColor = .systemBackground
	}
	
	private func configureTableView() {
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 400
		tableView.allowsSelection = false
		
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(
			MovieTableViewCell.self, 
			forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier
		)
		tableView.separatorStyle = .none
		
		tableView.addAsSubview(of: view)
		tableView.pin(to: view)
	}
	
	private func configureErrorContentView() {
		errorContentView.addAsSubview(of: view)
		errorContentView.align(toCenterOf: view)
	}
	
	private func configureActivityIndicatorView() {
		activityIndicatorView.addAsSubview(of: view)
		activityIndicatorView.squareOff(withSide: 44)
		activityIndicatorView.align(toCenterOf: view)
	}
	
	private func configureAppearancesOfEachViewAsPerState() {
		DispatchQueue.main.async { [weak self] in
			guard let `self` = self else { return }
			
			switch state {
			case .undetermined:
				tableView.hide()
				errorContentView.hide()
				activityIndicatorView.startAnimating()
				activityIndicatorView.show()
			case .data:
				errorContentView.hide()
				activityIndicatorView.hide()
				tableView.show()
				tableView.reloadData()
			case .error:
				errorContentView.configure(
					withImage: UIImage(systemName: "bandage")!,
					title: "Something went wrong"
				)
				tableView.hide()
				activityIndicatorView.hide()
				errorContentView.show()
			}
		}
	}
}

extension MovieViewController {
	private func fetchMovie() async {
		guard let omdbAPIKey = Bundle.main.infoDictionary?["OMDB_API_KEY"] else {
			state = .error
			return
		}
		
		guard let url = URL(string: "https://www.omdbapi.com?apikey=\(omdbAPIKey)&i=\(movieId)") else {
			state = .error
			return
		}
		
		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			
			let decoder = JSONDecoder()
			
			if let json = String(data: data, encoding: .utf8) {
				print(json)
			}
			
			let movie = try decoder.decode(
				MovieModel.self,
				from: data
			)
			
			state = .data(movie: movie)
		} catch {
			print(error)
			state = .error
		}
	}
}

extension MovieViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		1
	}
	
	func tableView(
		_ tableView: UITableView, 
		numberOfRowsInSection section: Int
	) -> Int {
		switch state {
		case .data:
			return 1
		default:
			return 0
		}
	}
	
	func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		switch state {
		case .data(movie: let movie):
			guard let movieTableViewCell = tableView.dequeueReusableCell(
				withIdentifier: MovieTableViewCell.reuseIdentifier,
				for: indexPath
			) as? MovieTableViewCell else {
				fatalError("Unable to dequeue MovieTableViewCell for identifier: \(MovieTableViewCell.reuseIdentifier)")
			}
		
			movieTableViewCell.configure(withMovie: movie)
			
			return movieTableViewCell
		default:
			fatalError("Empty state has no rows to dequeue.")
		}
	}
}

extension MovieViewController: UITableViewDelegate {
	
}
