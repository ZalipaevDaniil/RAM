//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 01.11.2024. 1
//
import UIKit
import Combine

final class EpisodesCellViewModel {
    //MARK: Private Properties
    private var episodeList: [String] {
        character.episode
    }

    var character: CharacterResult!
    var episodes: [EpisodeResult] = []
    var nameCharacter:String {character.name}
    var imageData: Data?
    var nameEpisode: String  {
        guard !episodes.isEmpty else { return "No episode" }
        return "\(episodes[0].name) | \(episodes[0].numberEpisode)"
    }
    
    var isFavorite: Bool {
        get { userDefaultsService.getFavoriteStatus(forKey: character.id)}
        set { userDefaultsService.setFavoritesStatus(forKey: character.id, witch: newValue)}
    }
    
    var imageURL: String? {
        didSet {
            imageData = nil //сбрасывает старые данные изображения
            getImage(){}
        }
    }
    
    var didChange: ((EpisodesCellViewModel) -> Void)?
    
    //MARK: Private Property
    private let dependency: Dependencies
    private let networkService: NetworkService
    private let userDefaultsService: UserDefaultsService
    private var isLoading = false
    private let imageCacheManager: ImageCacheManager
    
    init(dependency: Dependencies, character: CharacterResult) {
        self.dependency = dependency
        self.character = character
        networkService = dependency.networkService as! NetworkService
        userDefaultsService = dependency.userDefaultService as! UserDefaultsService
        imageCacheManager = dependency.imageCacheManager
    }

    //MARK: Public Methods
    
    func fetchCharacter(completion: @escaping() -> Void) {
        for url in episodeList {
            networkService.fetch(EpisodeResult.self, from: url) { [weak self] result in
                switch result {
                case .success(let episode):
                    self?.episodes.append(episode)
//                    print("Save episode: \(String(describing: self?.episodes))")
                    completion()
                case .failure(let error):
                    print("Failed to loaded episode: \(error.localizedDescription)")
                }
            }
        }

    }

    func fetchImage(completion: @escaping() -> Void) {
        guard let imageURL = imageURL else {return}
        guard URL(string: imageURL) != nil else { return }
        
        networkService.fetchImage(from: imageURL) { [ weak self ] result in
            switch result {
            case .success(let data):
                if imageURL == self?.imageURL {
                    self?.imageData = data
                    completion()
                }
            case .failure(let error):
                print("Failed to fatch image: \(error)")
            }
        }
    }
    
    func getImage(completion: @escaping() -> Void) {
        guard let imageURL = self.imageURL else { return }
        
        imageCacheManager.getImage(from: imageURL, witch: dependency) { [ weak self ] result in
            switch result {
            case .success(let data):
                if imageURL == self?.imageURL {//проверить, что URL не изменился
                    self?.imageData = Data(data)
                    completion()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
