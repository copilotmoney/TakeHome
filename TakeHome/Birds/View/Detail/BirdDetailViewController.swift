//
//  BirdDetailViewController.swift
//  TakeHome
//
//  Created by Josue Hernandez on 2024-08-10.
//

import UIKit
import SDWebImage

class BirdDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    let bird: Bird
    var notes: [String] = [] // This will store the list of community notes
    
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
        tableView.estimatedRowHeight = 44.0
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
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addNoteTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializers
    
    init(bird: Bird) {
        self.bird = bird
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
            stackView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -20)
        ])
        
        // Set constraints for the add button
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Set constraints for the imageView to limit its height
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    // MARK: - Configuration
    
    private func configure(with bird: Bird) {
        nameLabel.text = bird.nameEnglish
        imageView.sd_setImage(with: URL(string: bird.fullImageUrl), completed: nil)
        
        // Load notes if any exist (this would usually come from a data source or API)
        // Example notes added for demonstration
        notes = ["I saw it last week in North Carolina!", "Beautiful bird!", "It's rare to spot these!"]
        notesTableView.reloadData()
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
            self.notes.append(noteText)
            self.notesTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension BirdDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row]
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
