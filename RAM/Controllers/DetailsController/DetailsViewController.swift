//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 26.10.2024.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    //MARK: Private properties
    private let characterImage = UIImageView()
    private let cameraButton = UIButton()
    private let nameLabel = UILabel()
    private let infoTableView = DetailsInfoTableView()
    
    var viewModel: EpisodesCellViewModel! {
        didSet {
            infoTableView.character = viewModel.character
            viewModel.imageURL = viewModel.character.image
            viewModel.getImage {[weak self] in
                guard let imageData = self?.viewModel.imageData else {return}
                self?.characterImage.image = UIImage(data: imageData)
            }
            nameLabel.text = viewModel.nameCharacter
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
}

//MARK: UI
private extension DetailsViewController {
    func setupUI() {
        view.backgroundColor = .backGround
        setupCharacterImage()
        setupCameraButton()
        setupNameCharacter()
        setupInfoTableView()
        
    }
    
    func setupCharacterImage() {
        view.addSubview(characterImage)
        characterImage.translatesAutoresizingMaskIntoConstraints = false
        characterImage.contentMode = .scaleAspectFit
        characterImage.clipsToBounds = true
        
        characterImage.layer.cornerRadius = 75
        characterImage.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        characterImage.layer.borderWidth = 4
        setupCharacterImageConstraint()
    }
    
    func setupCameraButton() {
        view.addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.setImage(UIImage(named: "camera"), for: .normal)
        cameraButton.tintColor = UIColor(named: "cameraColor")
        
        //addTarget
        
        setupCameraButtonConstraint()
    }
    
    func setupNameCharacter() {
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 32)
        nameLabel.textColor = UIColor(named: "cameraColor")
        nameLabel.textAlignment = .center
        nameLabel.sizeToFit()
        setupNameLabelConstraint()
    }
    
    func setupInfoTableView() {
        view.addSubview(infoTableView)
        infoTableView.translatesAutoresizingMaskIntoConstraints = false
        setupTableConstraint()
    }
    
    //MARK: Setup Constraint Methods
    func setupCharacterImageConstraint() {
        NSLayoutConstraint.activate([
            characterImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            characterImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            characterImage.widthAnchor.constraint(equalToConstant: 147),
            characterImage.heightAnchor.constraint(equalTo: characterImage.widthAnchor)
        ])
    }
    
    func setupCameraButtonConstraint() {
        NSLayoutConstraint.activate([
            cameraButton.centerYAnchor.constraint(equalTo: characterImage.centerYAnchor),
            cameraButton.leadingAnchor.constraint(equalTo: characterImage.trailingAnchor, constant: 10)
        ])
    }
    
    func setupNameLabelConstraint(){
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: characterImage.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: characterImage.bottomAnchor, constant: 49)
        ])
    }
    
    func setupTableConstraint() {
        NSLayoutConstraint.activate([
            infoTableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 18),
            infoTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            infoTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
}

