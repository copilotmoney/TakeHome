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
    
    // Empty state view
    private let emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.isHidden = true
        return view
    }()
    
    // No results label
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No matching birds found."
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .center
        label.isHidden = true // Initially hidden
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupSearchController()
        setupCollectionView()
        setupLoadingIndicator()
        setupEmptyStateView()
        setupNoResultsLabel()
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
    
    private func setupEmptyStateView() {
        view.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        emptyStateView.onRetry = { [weak self] in
            self?.loadData()
        }
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
    
    private func setupNoResultsLabel() {
        view.addSubview(noResultsLabel)
        noResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noResultsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noResultsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$birds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] birds in
                guard let self = self else { return }
                if birds.isEmpty && self.viewModel.error == nil {
                    // This means we're still loading or haven't fetched data yet, don't show the empty state
                    return
                }
                self.loadingIndicator.stopAnimating()
                if birds.isEmpty {
                    self.showEmptyState()
                } else {
                    self.filteredBirds = birds
                    self.collectionView.reloadData()
                    self.showContent()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.loadingIndicator.stopAnimating()
                    print("Error: \(error)")
                    self?.showEmptyState()
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadData() {
        // Start loading indicator
        loadingIndicator.startAnimating()
        
        // Hide content and empty view
        collectionView.isHidden = true
        emptyStateView.isHidden = true
        
        // Load the birds data
        viewModel.loadBirds()
    }
    
    private func showEmptyState() {
        emptyStateView.isHidden = false
        collectionView.isHidden = true
    }
    
    private func showContent() {
        emptyStateView.isHidden = true
        collectionView.isHidden = false
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
            noResultsLabel.isHidden = !filteredBirds.isEmpty
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
        noResultsLabel.isHidden = !filteredBirds.isEmpty
    }
}
