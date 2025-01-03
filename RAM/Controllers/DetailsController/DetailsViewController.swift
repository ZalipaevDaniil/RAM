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
        setupNavigationBar()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Private objc-c Methods
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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
    
    func setupNavigationBar() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "goback"), for: .normal)
        backButton.setAttributedTitle(NSAttributedString(string: " GO BACK ",
                                                         attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)]), for: .normal)
        //costomize content inside in button
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.tintColor = .black
        backButton.contentHorizontalAlignment = .leading
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for:.touchUpInside )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let rightImage = UIImageView(image: UIImage(named: "characterTitleImage"))
        rightImage.contentMode = .scaleAspectFit
        rightImage.clipsToBounds = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightImage)
        
        navigationController?.navigationBar.tintColor = UIColor(named: "navTintColor")
        
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
            cameraButton.leadingAnchor.constraint(equalTo: characterImage.trailingAnchor, constant: 8),
            cameraButton.widthAnchor.constraint(equalToConstant: 24),
            cameraButton.heightAnchor.constraint(equalToConstant: 21)
            
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

//MARK: Gesture Recognizer Delegate
extension DetailsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
