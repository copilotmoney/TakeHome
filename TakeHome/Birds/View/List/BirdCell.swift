//
//  BirdCell.swift
//  TakeHome
//
//  Created by Josue Hernandez on 2024-08-09.
//

import UIKit
import SDWebImage

/// A custom UICollectionViewCell that displays a bird's image and name.
/// The cell features a rounded image with a gradient overlay at the bottom, and subtle shadows for better visual appeal.
class BirdCell: UICollectionViewCell {
    // MARK: - Properties

    /// A static identifier for reusing the cell.
    static let identifier = "BirdCell"
    
    /// The UIImageView that displays the bird's thumbnail image with a gradient overlay.
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    /// A UILabel that displays the bird's English name.
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.layer.masksToBounds = true
        return label
    }()
    
    /// A gradient layer for the bottom part of the image view, aligning with the name label.
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        gradient.locations = [0.0, 1.0]
        return gradient
    }()
    
    // MARK: - Initializers

    /// Initializes the cell with the provided frame.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupShadows()
    }
    
    /// Required initializer with coder. Not implemented as this cell is created programmatically.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Watermark
    func watermarkImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let session = URLSession.shared
        
        // Download the image from the URL
        session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Image 
            guard let image = UIImage(data: data), let jpegData = image.jpegData(compressionQuality: 1.0) else {
                completion(.failure(NSError(domain: "Invalid Image", code: 0, userInfo: nil)))
                return
            }
            
            // Prepare the URL request for watermarking
            var request = URLRequest(url: URL(string: "https://us-central1-copilot-take-home.cloudfunctions.net/watermark")!)
            request.httpMethod = "POST"
            request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
            request.setValue("\(jpegData.count)", forHTTPHeaderField: "Content-Length")
            request.httpBody = jpegData
            
            // Send the image data to the watermark API
            session.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(error!))
                    return
                }
                
                guard let watermarkedImage = UIImage(data: data) else {
                    completion(.failure(NSError(domain: "Invalid Watermarked Image", code: 0, userInfo: nil)))
                    return
                }
                
                // Return the watermarked image
                completion(.success(watermarkedImage))
            }.resume()
            
        }.resume()
    }
    
    
    // MARK: - Layout
    
    /// Lays out subviews and configures their frames.
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        
        // Set the gradient layer to match the height of the label
        let gradientHeight: CGFloat = 40
        gradientLayer.frame = CGRect(x: 0, y: contentView.frame.height - gradientHeight, width: contentView.frame.width, height: gradientHeight)
        
        nameLabel.frame = CGRect(x: 0, y: contentView.frame.size.height - gradientHeight, width: contentView.frame.size.width, height: gradientHeight)
    }
    
    // MARK: - Configuration

    /// Configures the cell with the provided bird data.
    /// - Parameter bird: The bird object containing the data to display in the cell.
    func configure(with bird: Bird) {
        nameLabel.text = bird.nameEnglish
        
        // Start by showing a placeholder image
        imageView.image = UIImage(named: "placeholder")
        
        // Fetch and watermark the image
        if let url = URL(string: bird.thumbImageUrl) {
            watermarkImage(from: url) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let watermarkedImage):
                        self?.imageView.image = watermarkedImage
                    case .failure(let error):
                        print("Failed to watermark image: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    // MARK: - Setup Methods
    
    /// Sets up the cell's views and adds them to the content view.
    private func setupViews() {
        contentView.addSubview(imageView)
        imageView.layer.addSublayer(gradientLayer)
        contentView.addSubview(nameLabel)
    }
    
    /// Configures the cell's shadow properties for a subtle depth effect.
    private func setupShadows() {
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = false
    }
}
