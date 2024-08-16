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
		configureView()
		configureTableView()
		configureErrorContentView()
		configureActivityIndicatorView()
		
		configureAppearancesOfEachViewAsPerState()
	}
	
	private func configureView() {
		view.backgroundColor = .systemBackground
	}
	
	private func configureTableView() {
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
		switch state {
		case .undetermined:
			tableView.hide()
			errorContentView.hide()
			activityIndicatorView.startAnimating()
			activityIndicatorView.show()
		case .data(let movie):
			tableView.reloadData()
			errorContentView.hide()
			activityIndicatorView.hide()
			tableView.show()
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
			
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "dd MMM yyyy"
			
			decoder.dateDecodingStrategy = .formatted(dateFormatter)
			
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
