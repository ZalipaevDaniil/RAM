//
//  LaunchViewController.swift
//  RickandMorty
//
//  Created by Aaa on 26.08.2024.
//

import UIKit

final class LaunchViewController: UIViewController {
    

    var didSendEventClosure:((LaunchViewController.Event) -> Void)?
    
    //MARK: UI Elements
    private lazy var mainImageView: UIImageView = makeMainImageView()
    private lazy var backLoadImageView: UIImageView = makeBackLoadImageView()
    private lazy var loadImageView: UIImageView = makeLoadImageView()
    
    //MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = (UIColor(named: "BackGroundColor"))
        
        setupUI()
        startRotationAnimation()
    }
    
    
    private func startRotationAnimation() {
        UIView.animate(withDuration: 3.0, delay: 0, options: [.curveEaseInOut]) {
            self.loadImageView.transform = CGAffineTransform(rotationAngle: .pi)
        } completion: { [weak self] _ in
            self?.didSendEventClosure?( .launchComplete )
            
        }
        
    }
}
    

    


 //MARK: - UI
private extension LaunchViewController {
    func setupUI() {
        setupConstraintMainImage()
    }
    
    func makeMainImageView() -> UIImageView {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "MainImageLaunch")
        return image
    }
    
    func makeBackLoadImageView() -> UIImageView {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "LoadingBackground")
        return image
    }
    
    func makeLoadImageView() -> UIImageView {
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "Loading")
        return image
    }
    
    func setupConstraintMainImage() {
        view.addSubview(mainImageView)
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 42),
            mainImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainImageView.widthAnchor.constraint(equalToConstant: 312),
            mainImageView.heightAnchor.constraint(equalToConstant: 106)
        ])
        
        view.addSubview(backLoadImageView)
        NSLayoutConstraint.activate([
            backLoadImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backLoadImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backLoadImageView.widthAnchor.constraint(equalToConstant: 334),
            backLoadImageView.heightAnchor.constraint(equalToConstant: 393),
        ])
        
        view.addSubview(loadImageView)
        NSLayoutConstraint.activate([
            loadImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadImageView.widthAnchor.constraint(equalToConstant: 195),
            loadImageView.heightAnchor.constraint(equalToConstant: 207),
        ])
    }
}


extension LaunchViewController {
    enum Event {
        case launchComplete
    }
}



