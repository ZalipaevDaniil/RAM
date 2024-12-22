//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 01.11.2024. 3
//
import Foundation
import UIKit
import Combine


final class EpisodeViewModel {
    
    //MARK: Public Property
    var pageModel: EpisodesResponse?
    var characters : [CharacterResponse] = []
    var allCharacters : [CharacterResponse] = []
    var favoritesCharacters : [CharacterResponse] = []
    var dependencies: Dependencies

    //MARK: Filter Public Property
    //var filtersEpisode: [CharacterResponse] = []
    //var filteredLink = "https://rickandmortyapi.com/api/character/"
    
    //MARK: Private Properties
    private let networkService: NetworkServiceProtocol
    private let userDefaultService: UserDefaultsServiceProtocol
    //флаги
    private var isStatusSelected = false
    private var isGenderSelected = false
    //строки запоминают прошлый параметр фильтра
    private var previousStatus: String?
    private var previousGender: String?
    
    //MARK: Initialization
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.networkService = dependencies.networkService
        self.userDefaultService = dependencies.userDefaultService
        
        //Загружает сохраненные данные из UserDefaults in array Episodes

    }

    //MARK: Public Methods
    
    func fetchCharacters(from url: String, completion: @escaping() -> Void) {
        networkService.fetch(EpisodesResponse.self, from: url) { [weak self] result in
            DispatchQueue.main.async {
                self?.fetchByFilterHundler(result, completion)
            }
            
        }
    }
    
    
    func updateCharacters(from url: String, completion: @escaping(_ newCount: Int) -> Void) {
        networkService.fetch(EpisodesResponse.self, from: url) { [weak self] result in
            switch result {
            case .success(let page) :
                self?.pageModel = page
                self?.characters += page.results
                completion(page.results.count)
            case .failure(let error) :
                print("Error: \(error)")
            
            }
            
        }
    }
    
    func getAllCharacters(from url: String, completion: @escaping() -> Void) {
        networkService.fetch(EpisodesResponse.self, from: url) { [weak self] result in
            switch result {
            case .success(let page):
                self?.allCharacters += page.results
                if page.info.next == nil {
                    completion()
                }
                
                guard let nextPage = page.info.next else {return}
                self?.getAllCharacters(from: nextPage, completion: {
                    completion()
                })
                        
                        
            case .failure(let error):
                print("Error: \(error)")
            }
            
        }
    }
    
    func filterFavoritesCharacters() {
        print("All characters count: \(allCharacters.count)")
        allCharacters.forEach { print("Character ID: \($0.id)")}
        favoritesCharacters = allCharacters.filter{
            let isFavorite = userDefaultService.getFavoriteStatus(forKey: $0.id)
            print("Character ID: \($0.id), isFavorite: \(isFavorite)")
            return isFavorite
        }
        print("favoritesCharacters: \(favoritesCharacters.count)")
    }
    
    //MARK: Private Methods
    private func fetchByFilterHundler(_ result: Result<EpisodesResponse, NetworkError>, _ completion: @escaping() -> Void) {
        switch result {
        case .success(let page):
            self.pageModel = page //сохраняем текущую страницу данных
            self.characters = page.results //обновляем массив персонажей
            completion() 
        case .failure(let error):
            print(error)
        }
    }
}
    

    
    
//case .success(let fetchedCharacters):
//    self.episodes.append(fetchedCharacters)
//    self.characterPublisher.send(self.episodes)
//    
//    self.userDefaultManager.saveCharacters(self.episodes)
//case .failure(let error) :
//    print("Error loading episodes: \(error)")
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    //MARK: Public Methods
//    ///метод загруужающий данные об эпизоде в массив
//    func fetchEpisodes() {
//        
//    }
//    
//    ///метод загружающий дополнительные данные для ПАГИНАЦИИ(при прокрутке страницы)
//    func updateEpisodes() {
//        
//    }
//    
//    ///загружает всех персонажей начиная с указанного URL
//    func getAllCharacters() {
//        
//    }
//    
//    
//    ///метод отвечает за загрузку данных и обновление массива
//    func fetchData(completion: @escaping() -> Void){
//        episodeMock = DataMock.shared.character
//        print("Данные загружены: \(episodeMock.count)")
//        completion()
//    }
//    
//    //MARK: Private Methods
//    private func fetchByFilterHundler() {
//        
//    }
//    
//}



    
    //MARK: Public Methods
    
    //func filteredFavoritesEpisodes - фильрует эпизоды сохраненные в избранное проверяя через UserDefaultsManager
    
   

    //MARK: Flag Filter Status
    
    //func statusSelected - метод для фильтрации персонажа по статусу жизни
    // - нужно создать строку sublink с выбранным статусом
    // - проверить если фильтр статуса уже активирован и выбран тот же статус
    
    //func statusGender - метод для фильтрации персонажей по полу.
    
//MARK: Private Methods
//    private func fetchByFilterHandler(
//    
//}


