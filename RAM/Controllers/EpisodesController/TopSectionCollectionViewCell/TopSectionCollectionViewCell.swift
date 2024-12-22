//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 04.11.2024.
//

import UIKit

final class TopSectionCollectionViewCell: UICollectionViewCell {
    
    
    //MARK: Public Property
    static let reuseID: String = "TopSection"
    var viewModel: EpisodeViewModel?
    weak var delegateTopSection: TopSectionCollectionViewControllerDelegate?
    
    //MARK: Private Property
    private let imageView = UIImageView()
    private let searchTextField = UITextField()
    private let filterButton = UIButton(type: .system)
    
    //MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
    //MARK: - Private Methods
    private extension TopSectionCollectionViewCell {
        func setupUI() {
            contentView.backgroundColor = UIColor(named: "BackGroundColor")
            setupImageView()
            setupSearchTextField()
            setupFilterButton()
            
            
        }
        
        func setupImageView() {
            imageView.image = UIImage(named: "MainImageLaunch")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            contentView.addSubview(imageView)
            setupConstraintImageView()
            
        }
        
        func setupSearchTextField() {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 24))
            let imageView = UIImageView(image: UIImage(named: "search"))
            imageView.tintColor = UIColor(named: "searchColor")
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: view.frame.width - 24 / 2 + 5, y: 0, width: 24, height: 24)
            view.addSubview(imageView)
            searchTextField.translatesAutoresizingMaskIntoConstraints = false
            searchTextField.clipsToBounds = true
            searchTextField.placeholder = "Name or episode (ex.S01E01)..."
            searchTextField.borderStyle = .roundedRect
            searchTextField.tintColor = .darkGray
            
            searchTextField.layer.cornerRadius = 8
            contentView.addSubview(searchTextField)
            setupConstraintSearchTextField()
        }
        
        func setupFilterButton() {
            let image = UIImageView(image: UIImage(named: "filter"))
            image.tintColor = .black
            image.contentMode = .scaleAspectFit
            filterButton.addSubview(image)
            image.frame = CGRect(x: 19, y: 12, width: 18, height: 12)
            
            filterButton.backgroundColor = UIColor(named: "backFilterButtonColor")
            filterButton.setTitle("ADVANCED FILTERS", for: .normal)
            filterButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
            filterButton.layer.cornerRadius = 4
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            filterButton.clipsToBounds = true
            filterButton.contentMode = .scaleAspectFit
            
            contentView.addSubview(filterButton)
            setupConstraintFilterButton()
        }
        
        func setupConstraintImageView() {
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                imageView.heightAnchor.constraint(equalToConstant: 100)
            ])
            
        }
        
        func setupConstraintSearchTextField() {
            NSLayoutConstraint.activate([
                searchTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 60),
                searchTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                searchTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                searchTextField.heightAnchor.constraint(equalToConstant: 56)
                
            ])
        }
        
        func setupConstraintFilterButton() {
            NSLayoutConstraint.activate([
                filterButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 12),
                filterButton.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                filterButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                filterButton.heightAnchor.constraint(equalToConstant: 56)
                
            ])
        }
        
    }
    
    

