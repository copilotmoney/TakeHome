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
    
    private let bird: Bird
    
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
    
    private let latinNameLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
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
        view.addSubview(stackView)
        
        // Add arranged subviews to the stack view
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(latinNameLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        // Set constraints for the stack view
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        // Set constraints for the imageView to limit its height
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    // MARK: - Configuration
    
    private func configure(with bird: Bird) {
        nameLabel.text = bird.nameEnglish
        latinNameLabel.text = bird.nameLatin
        imageView.sd_setImage(with: URL(string: bird.fullImageUrl), completed: nil)
        
        // Example description content, you can adjust or replace this with actual bird data
        descriptionLabel.text = "This is a detailed description of the bird, including its behavior, habitat, and any other relevant information."
    }
}
