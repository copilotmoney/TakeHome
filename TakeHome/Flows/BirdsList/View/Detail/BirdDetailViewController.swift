//
//  BirdDetailViewController.swift
//  TakeHome
//
//  Created by Josue Hernandez on 2024-08-10.
//

import UIKit
import Combine
import SDWebImage

class BirdDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    let bird: Bird
    var birdNotes: [Note] = []
    
    var viewModel: NoteViewModel!
    
    private var cancellables: Set<AnyCancellable> = []
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let notesLabel: UILabel = {
        let label = UILabel()
        label.text = "Community Notes"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private let notesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NoteCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50.0
        return tableView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("add a note", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.addTarget(self, action: #selector(addNoteTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializers
    
    init(bird: Bird, viewModel: NoteViewModel) {
        self.bird = bird
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        configure(with: bird)
        bindViewModel()
    }
    
    // MARK: - Setup Methods
    
    private func setupViews() {
        notesTableView.delegate = self
        notesTableView.dataSource = self
        
        view.addSubview(stackView)
        view.addSubview(addButton)
        
        // Add arranged subviews to the stack view
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(notesLabel)
        stackView.addArrangedSubview(notesTableView)
        
        // Set constraints for the stack view
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: addButton.topAnchor, constant: -20)
        ])
        
        // Set constraints for the add button
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        // Set constraints for the imageView to limit its height
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    private func bindViewModel() {
        viewModel.$birsSelected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bird in
                guard let self = self else { return }
                self.birdNotes = bird?.notes ?? []
                self.updateNotesLabelAndTableView()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Configuration
    
    private func configure(with bird: Bird) {
        nameLabel.text = bird.nameEnglish
        imageView.sd_setImage(with: URL(string: bird.fullImageUrl), completed: nil)
        birdNotes = bird.notes ?? []
        
        updateNotesLabelAndTableView()
    }
    
    private func updateNotesLabelAndTableView() {
        if birdNotes.isEmpty {
            notesLabel.text = "No community notes available"
            notesTableView.isHidden = true
        } else {
            notesLabel.text = "Community Notes"
            notesTableView.isHidden = false
            
            let tableViewHeight = CGFloat(birdNotes.count) * notesTableView.estimatedRowHeight
            notesTableView.heightAnchor.constraint(equalToConstant: tableViewHeight).isActive = true
        }
        
        notesTableView.reloadData()
        notesTableView.layoutIfNeeded()
    }
    
    // MARK: - Actions
    
    @objc private func addNoteTapped() {
        let alertController = UIAlertController(title: "New Note", message: "Add your note below:", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter your note"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self, let noteText = alertController.textFields?.first?.text, !noteText.isEmpty else {
                return
            }
            
            // Persist the note through the service
            self.viewModel.addNote(content: noteText, userID: UUID().uuidString, birdSelected: self.bird)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension BirdDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return birdNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        cell.textLabel?.text = birdNotes[indexPath.row].content
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.backgroundColor = UIColor(white: 0.94, alpha: 1)
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
