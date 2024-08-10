//
//  MainViewController.swift
//  TakeHome
//
//  Created by Josue Hernandez on 2024-08-08.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    //coordinator
    weak var coordinator: MainCoordinator?
    
    var collectionView: UICollectionView!
    var viewModel: BirdsViewModel!
    var cancellables = Set<AnyCancellable>()
    
    private var filteredBirds: [Bird] = []
    private var searchController: UISearchController!
    
    // Loading indicator
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupSearchController()
        setupCollectionView()
        setupLoadingIndicator()
        bindViewModel()
        
        // Load the birds data with loading indicator
        loadData()
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Birds"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.size.width / 2) - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BirdCell.self, forCellWithReuseIdentifier: BirdCell.identifier)
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView)
    }
    
    private func setupLoadingIndicator() {
        // Add loading indicator to the view
        view.addSubview(loadingIndicator)
        
        // Center the loading indicator in the view
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$birds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] birds in
                self?.loadingIndicator.stopAnimating()
                self?.filteredBirds = birds
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.loadingIndicator.stopAnimating()
                    print("Error: \(error)")
                    // Optionally, show an alert or error message to the user
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadData() {
        // Start loading indicator
        loadingIndicator.startAnimating()
        
        // Load the birds data
        viewModel.loadBirds()
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredBirds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BirdCell.identifier, for: indexPath) as! BirdCell
        let bird = filteredBirds[indexPath.row]
        cell.configure(with: bird)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBird = filteredBirds[indexPath.row]
        coordinator?.presentBirdDetailSheet(for: selectedBird)
    }
}


// MARK: - UISearchResultsUpdating

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            filteredBirds = viewModel.birds
            collectionView.reloadData()
            return
        }
        
        if searchText.isEmpty {
            filteredBirds = viewModel.birds
        } else {
            filteredBirds = viewModel.birds.filter { bird in
                return bird.nameEnglish.lowercased().contains(searchText)
            }
        }
        
        collectionView.reloadData()
    }
}
