//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 01.11.2024. 3
//
import Foundation
import UIKit
import Combine

//MARK: Enum Filters
enum SearchByEpisode: String {
    case byName = "Name episode (Pilot)..."
    case byNumber = "Number episode (ex.S01E01)..."
}

enum FiltersByStatus: String {
    case alive = "alive"
    case dead = "dead"
    case unknown = "unknown"
}

enum FiltersByGender: String {
    case female = "female"
    case male = "male"
    case genderless = "genderless"
    case unknown = "unknown"
}

final class EpisodeViewModel {
    
    //MARK: Public Property
    var pageModel: Character?
    var characters : [CharacterResult] = []
    var allCharacters : [CharacterResult] = []
    var favoritesCharacters : [CharacterResult] = []
    var dependencies: Dependencies
    
    //MARK: Filter Public Property
    var filteredLink = "https://rickandmortyapi.com/api/character/?"
    
    //MARK: Search Public Property
    
    
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
        networkService.fetch(Character.self, from: url) { [weak self] result in
            DispatchQueue.main.async {
                self?.fetchByFilterHundler(result, completion)
            }
        }
    }
    
    func updateCharacters(from url: String, completion: @escaping(_ newCount: Int) -> Void) {
        networkService.fetch(Character.self, from: url) { [weak self] result in
            switch result {
            case .success(let page) :
                self?.pageModel = page //сохраняет текущую страницу
                self?.characters += page.results // добавляет персонажей в characters
                completion(page.results.count)//для обновления количества ячеек
            case .failure(let error) :
                print("Error: \(error)")
            }
        }
    }
    
    func getAllCharacters(from url: String, completion: @escaping() -> Void) {
        networkService.fetch(Character.self, from: url) { [weak self] result in
            switch result {
            case .success(let page):
                self?.allCharacters += page.results
                if page.info?.next == nil {
                    completion()
                }
                guard let nextPage = page.info?.next else {return}
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
        favoritesCharacters = allCharacters.filter{
            let isFavorite = userDefaultService.getFavoriteStatus(forKey: $0.id)
            //            print("Character ID: \($0.id), isFavorite: \(isFavorite)")
            return isFavorite
        }
        print("favoritesCharacters: \(favoritesCharacters.count)")
    }
    
    //MARK: Search Methods
    func searchEpisodes(query: String, completion: @escaping() -> Void) {
        
        filterEpisodeByEpisode(episode: query, completion: completion)
    }
    
    
    //MARK: Filters Methods
    func statusSelected(status: FiltersByStatus, completion: @escaping() -> Void) {
        let currentStatus = status.rawValue
        let subLink = "&status=\(currentStatus)"
        
        if !isStatusSelected {// Фильтр ещё не выбран
            filteredLink += subLink
            previousStatus = subLink
            isStatusSelected.toggle()
        } else if isStatusSelected && previousStatus != subLink {
            // Фильтр уже выбран, но выбранное значение изменилось
            guard let previousStatus = previousStatus else {return}
            filteredLink = filteredLink.replacingOccurrences(of: previousStatus, with: "")
            filteredLink += subLink
            self.previousStatus = subLink //почему здесь self.previous?
            //был ли применен филтр И совпадает ли предыдущий фильтр == с текущим
        } else if isStatusSelected && previousStatus == subLink {
            filteredLink = filteredLink.replacingOccurrences(of: subLink, with: "")
            isStatusSelected.toggle()
        }
        
        //запрос с отфильтрованными данными
        fetchCharacters(from: filteredLink, completion: completion)
    }
    
    func genderSelected(gender: FiltersByGender, completion: @escaping() -> Void) {
        let currentGender = gender.rawValue
        let subLink = "&gender=\(currentGender)"
        
        if !isGenderSelected {// Фильтр ещё не выбран
            filteredLink += subLink
            previousGender = subLink
            isGenderSelected.toggle()
        } else if isGenderSelected && previousGender != subLink {
            // Фильтр уже выбран, но выбранное значение изменилось
            guard let previousGender = previousGender else {return}
            filteredLink = filteredLink.replacingOccurrences(of: previousGender, with: "")
            filteredLink += subLink
            self.previousGender = subLink
        } else if isGenderSelected && previousGender == subLink {
            filteredLink = filteredLink.replacingOccurrences(of: subLink, with: "")
            isGenderSelected.toggle()
        }
        
        fetchCharacters(from: filteredLink, completion: completion) //-
    }
    
    //MARK: Private Methods
    private func fetchByFilterHundler(_ result: Result<Character, NetworkError>, _ completion: @escaping() -> Void) {
        switch result {
        case .success(let page):
            self.pageModel = page //сохраняем текущую страницу данных
            self.characters = page.results //обновляем массив персонажей
            completion()
        case .failure(let error):
            print(error)
        }
    }
    
    // MARK: Search Methods
    private func filterEpisodeByEpisode (episode: String, completion: @escaping() -> Void) {
        print("Name:\(episode)")
        
        let urlEpisode = "https://rickandmortyapi.com/api/episode/?episode=\(episode)"
        print("URL Episode: \(urlEpisode)")//+
        
        networkService.fetch(Episode.self, from: urlEpisode) { [weak self] result in
            guard let self = self else {return }
            switch result {
            case .success(let episode):
                guard let episode = episode.results.first else {
                    return print("Episode not found")
                }
                
                let episodeURL = episode.characters
                print("Episode URL: \(episodeURL)")//+
                
                filterCharacterByURL(characterUrl: episodeURL) { [weak self] result in
                    self?.characters = result
                    completion()
                    }
                
            case .failure(let error):
                    print("Error fetching episode: \(error)")
                }
            }
        }
    
    private func filterCharacterByURL(characterUrl: [String], completion: @escaping([CharacterResult]) -> Void) {

        var array : [CharacterResult] = []
        let dispatchGroup = DispatchGroup()
        
        for url in characterUrl {
            dispatchGroup.enter()
            networkService.fetch(CharacterResult.self, from: url) { result in
                switch result {
                case .success(let character):
                    print("character : \(character)")
                    array += [character]
                case .failure(let error):
                    print("Error fetching characters from Episode: \(error)")
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            print("Array characters: \(array)")
            completion(array)
        }
        
    }

}
    
    
    
 


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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


