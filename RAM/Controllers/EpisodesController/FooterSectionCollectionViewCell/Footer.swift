//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 05.11.2024.
//

import UIKit

final class FooterLoadingCollectionResableView: UICollectionReusableView {
    
    //MARK: Static Properties
    static let reuseID  = "FooterReusableView"
    
    private let activityIndicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(activityIndicator)
        setupConstraints()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    public func startIndicator() {
        activityIndicator.startAnimating()
    }
    
    
}
