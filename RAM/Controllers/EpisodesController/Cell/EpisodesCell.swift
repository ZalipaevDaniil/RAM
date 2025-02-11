//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 31.10.2024. 2(передать cellViewModel) и вернуться в конце это уже 5
//

import UIKit

final class EpisodesCell: UICollectionViewCell {

    //MARK: Static Properties
    static let reuseID = "EpisodesCell"
    
    //MARK: Outlets
    private let characterImage = UIImageView()
    private let characterNameLabel = UILabel()
    private let bottomView = UIView()//
    private let monitorImage = UIImageView()//
    private let episodeNameLabel = UILabel()
    private let isFavoritesButton = UIButton(type: .system)//
    
    var viewModel: EpisodesCellViewModel? {
        didSet {
            viewModel?.imageURL = viewModel?.character.image
            viewModel?.getImage { [ weak self ] in
                guard let image = self?.viewModel?.imageData else{ return }
                self?.characterImage.image = UIImage(data: image)
                
            }
            characterNameLabel.text = viewModel?.nameCharacter
            viewModel?.fetchCharacter { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async{
                    self.episodeNameLabel.text = self.viewModel?.nameEpisode
                    
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    //MARK: Objc Methods
    @objc func ButtonTapped() {
        guard let isFavorite = viewModel?.isFavorite else {return}
            viewModel?.isFavorite.toggle()
        
        let imageName = isFavorite ? "likeImage" : "tappedLike"
        let color = isFavorite ? UIColor(named: "IsLikesButtonColor") : .red
        isFavoritesButton.setImage(UIImage(named: imageName), for: .normal)
        isFavoritesButton.tintColor = color
        viewModel?.didChange?(viewModel!)
  
        NotificationCenter.default.post(name: .favoritesDidUpdate, object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            let lightGenerator = UIImpactFeedbackGenerator(style: .light)
            lightGenerator.prepare()
            lightGenerator.impactOccurred()
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.isFavoritesButton.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        } ) { _ in
            UIView.animate(withDuration: 0.1) {
                self.isFavoritesButton.transform = CGAffineTransform.identity
            }
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//MARK: Setup UI
private extension EpisodesCell {
    func setupUI() {
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        contentView.backgroundColor = .backCell
        
        self.layer.shadowColor = UIColor.black.cgColor //Цвет
        self.layer.shadowRadius = 2 //Размытие
        self.layer.shadowOpacity = 0.4 //Прозрачность
        self.layer.shadowOffset = CGSize(width: 0, height: 2.5) //Смещение: вертикально вниз
        
        setupCharacterImage()
        setupCharacterName()
        setupBottomView()
        setupMonitorImage()
        setupIsFavoritesButton()
        setupEpisodeName()
        
        
        
    }
    
    
    
    func setupCharacterImage() {
        characterImage.translatesAutoresizingMaskIntoConstraints = false
        characterImage.contentMode = .scaleAspectFill
        
        characterImage.clipsToBounds = true
        contentView.addSubview(characterImage)
        characterImageConstraint()
    }
    
    func setupCharacterName() {
        characterNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        characterNameLabel.font = .systemFont(ofSize: 20, weight: .medium)
        characterNameLabel.textColor = .black
        
        characterNameLabel.clipsToBounds = true
        contentView.addSubview(characterNameLabel)
        characterNameConstraint()
    }
    
    func setupBottomView() {
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.contentMode = .scaleAspectFit
        
        bottomView.layer.cornerRadius = 16
        bottomView.backgroundColor = UIColor(named: "BottomViewColorEpisode")
        
        bottomView.clipsToBounds = true
        contentView.addSubview(bottomView)
        bottomViewConstraint()
    }
    
    func setupMonitorImage() {
        monitorImage.translatesAutoresizingMaskIntoConstraints = false
        monitorImage.contentMode = .scaleAspectFit
        monitorImage.image = UIImage(named: "monitorEpisodeImage")
        monitorImage.clipsToBounds = true
        bottomView.addSubview(monitorImage)
        monitorImageConstraint()
    }
    
    func setupEpisodeName() {
        episodeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        episodeNameLabel.font = .systemFont(ofSize: 16)
        episodeNameLabel.textColor = .black
        
        episodeNameLabel.clipsToBounds = true
        bottomView.addSubview(episodeNameLabel)
        episodeNameConstraint()
        
    }
    
    func setupIsFavoritesButton() {
        let isFavorites = viewModel?.isFavorite ?? false
        
        isFavoritesButton.setImage(UIImage(named: isFavorites ? "likeImage" : "tappedLike") , for: .normal)
        isFavoritesButton.tintColor = isFavorites ? UIColor(named: "IsLikesButtonColor") : .red
        isFavoritesButton.addTarget(self, action: #selector(ButtonTapped), for: .touchUpInside)
        isFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(isFavoritesButton)
        IsFavoritesButton()
    }
    
    
    
    //MARK: Setup Constrints Methods
    
    func characterImageConstraint() {
        NSLayoutConstraint.activate([
            characterImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            characterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            characterImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.65)
        ])
    }
    
    func characterNameConstraint() {
        NSLayoutConstraint.activate([
            characterNameLabel.topAnchor.constraint(equalTo: characterImage.bottomAnchor),
            characterNameLabel.leadingAnchor.constraint(equalTo: characterImage.leadingAnchor, constant: 16),
            characterNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        print("characterName constraints applied")
    }
    func bottomViewConstraint() {
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 71),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        print("bottomView constraints applied")
    }
    func monitorImageConstraint() {
        NSLayoutConstraint.activate([
            monitorImage.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            monitorImage.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15),
            monitorImage.widthAnchor.constraint(equalToConstant: 33),
            monitorImage.heightAnchor.constraint(equalToConstant: 32)
        ])
        print("monitorImage constraints applied")
    }
    func episodeNameConstraint() {
        NSLayoutConstraint.activate([
            episodeNameLabel.centerYAnchor.constraint(equalTo: monitorImage.centerYAnchor),
            episodeNameLabel.leadingAnchor.constraint(equalTo: monitorImage.trailingAnchor, constant: 12),
            episodeNameLabel.trailingAnchor.constraint(equalTo: isFavoritesButton.leadingAnchor, constant: -8)
        ])
        print("EpisodeName constraints applied")
    }
    
    
    func IsFavoritesButton() {
        NSLayoutConstraint.activate([
            isFavoritesButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            isFavoritesButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20),
            isFavoritesButton.widthAnchor.constraint(equalToConstant: 36),
            isFavoritesButton.heightAnchor.constraint(equalToConstant: 30)
            
        ])
        print("IsFavoritesButton constraints applied")
    }
    
}

extension Notification.Name {
    static let favoritesDidUpdate = Notification.Name("favoritesDidUpdate")
}
