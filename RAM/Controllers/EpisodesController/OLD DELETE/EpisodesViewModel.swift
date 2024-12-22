//
//  EpisodesViewModel.swift
//  RAM
//
//  Created by Aaa on 06.09.2024.
//
//В общем, класс EpisodesViewModel отвечает за бизнес-логику приложения, управляя загрузкой данных о сериале и связанных персонажах, а также уведомляя представление о необходимости обновления. Он использует Combine для управления асинхронностью и взаимодействиями, чтобы создать отзывчивый и интерактивный интерфейс.

//import UIKit
//import Combine
//import UIScrollView_InfiniteScroll
//
//final class EpisodesViewModel {
//    
//    //MARK: Service
//    var networkService: INetworkService //Интерфейс для работы с сетью, который предоставляет функции для получения данных о эпизодах и персонажах.
//    private var userDefaultService: UserDefaultsService  //Интерфейс для работы с пользовательскими данными, для хранения и получения идентификаторов избранных эпизодов.
//    
//    //MARK: Public Properties
//    var episodesArray: [DetailEpisode] = []  //Массив, который хранит эпизоды, полученные из сети.
//    var characterURLs: [String] = [] //Массив, который хранит URL персонажей, найденных в эпизодах.
//    var showCharacters: [CharacterResponse] = []//Массив характеристик персонажей, которые должны отображаться.
//    var favEpisodesIDs: [Int] = []// Массив идентификаторов избранных эпизодов.
//    
//    let updateSnapshotRequest = PassthroughSubject<Void, Never>() //Публикует события когда данные обновляются и нужно обновить интерфейс
//    //Void указывает на то, что PassthroughSubject не передаёт никаких данных, когда он вызывает событие. Это значит, что это просто оповещение о том, что что-то произошло, но без дополнительных данных.
//    //Never означает, что этот PassthroughSubject никогда не будет выдавать ошибки. Это делает его безопасным для использования в сценариях, где вы не ожидаете, что будут возникать ошибки.
//    let stopIndicatorRequest = PassthroughSubject<Void, Never>()//Публикeет события для остановки индикатора загрузки.
//    let serieIdentifier = PassthroughSubject<String, Never>()//Публикация идентификатора сериала, чтобы фильтровать эпизоды по этому параметру.
//    
//    var subscriptions = Set<AnyCancellable>()//Набор для хранения подписок Combine.
//    
//    //MARK: Private properties
//    private var nextPageToLoad :Int = 1//Указывает, какую страницу эпизодов нужно загрузить следующей.
//    private let dispatchGroup = DispatchGroup()//Группа для синхронизации асинхронных задач (в данном случае, запросов к API для получения информации о персонажах).
//    
//    //MARK: Closure
//    
//    let didTapOnCharacter: (_ character: CharacterResponse) -> Void //Замыкание, которое вызывается, когда пользователь нажимает на персонажа.
//    
//    //MARK: Constructor
//    init(dependency: IDependencies, didTapOnCharacter: @escaping (_: CharacterResponse) -> Void) {
//        self.networkService = dependency.networkService
//        self.userDefaultService = dependency.userDefaultService as! UserDefaultsService
//        self.didTapOnCharacter = didTapOnCharacter
//        setupSubscriptions()
//        getFavEpisodesIDs()
//        
//    }
//    
//    //MARK: Public Methods
//    
//    public func getAllEpisodes(for collection: UICollectionView) {
//        getAndAddNewEpisodes(for: collection)//Сначала вызывается метод getAndAddNewEpisodes, который, отвечает за загрузку новых эпизодов и добавление их в UICollectionView.
//        
//        collection.infiniteScrollDirection = .vertical//Устанавливаются направления бесконечной прокрутки (.vertical)
//        collection.infiniteScrollIndicatorStyle = .large//и стиль индикатора загрузки (.large). Это настраивает внешний вид и поведение элементов бесконечной прокрутки.
//        
//        collection.addInfiniteScroll { [weak self] collection in
//            self?.getAndAddNewEpisodes(for: collection)//Здесь добавляется обработчик, который будет вызван, когда пользователь прокручивает до конца UICollectionView. Этот обработчик также вызывает метод getAndAddNewEpisodes, то есть при достижении конца списка будут загружаться новые эпизоды.
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                collection.finishInfiniteScroll()
//            }//После вызова метода для загрузки новых эпизодов код использует DispatchQueue.main.asyncAfter для задержки на 2 секунды перед завершением бесконечной прокрутки с помощью метода collection.finishInfiniteScroll(). Это может быть полезно для визуальной индикации, что загрузка завершена (например, если соединение быстрое и данные загружаются мгновенно).
//        }
//    }
//    
//    public func getFavEpisodesIDs() {
//        favEpisodesIDs = userDefaultService.retrieve()
//    }//Загружает идентификаторы избранных эпизодов из пользовательских настроек.
//    
//    private func getFilteredEpisodes(for serie: String) {
//        let defaultSortOrder: SortedEpisodes = .ascending
//        if serie == "" {
//            nextPageToLoad = 2
//        } else {
//            nextPageToLoad = Int.max
//        }
//        networkService.getFilteredEpisodes(for: serie, sortedE: defaultSortOrder) { [weak self] result in
//            switch result {
//            case .success(let response) :
//                let episodes: [DetailEpisode] = response.results
//                self?.episodesArray = []
//                self?.characterURLs = []
//                self?.showCharacters = []
//                self?.getAllCharacterURLs(from: episodes)
//                self?.characterURLs.forEach {
//                    self?.getShownCharacter(from: $0)
//                }
//                self?.dispatchGroup.notify(queue: .main) {
//                    self?.episodesArray.append(contentsOf: episodes)
//                    self?.updateSnapshotRequest.send()
//                    self?.stopIndicatorRequest.send()
//                }
//            case .failure(let error):
//                print(error.errorDescription)
//            }
//            
//        }
//    }
//    
//    //MARK: Private Methods
//    private func setupSubscriptions() {
//        serieIdentifier.sink {[unowned self] serie in
//            let sortOrder: SortedEpisodes = .ascending
//            getFilteredEpisodes(for: serie)
//        }.store(in: &subscriptions)
//    }
//    
//    private func getAndAddNewEpisodes(for collection: UICollectionView) {
//        networkService.getAllEpisodes(forPage: nextPageToLoad) { [weak self] result in
//            switch result {
//            case .success(let response):
//                let episodes :[DetailEpisode] = response.results//Извлекаются все эпизоды из ответа и сохраняются в массив episodes.
//                self?.getAllCharacterURLs(from: episodes)//вызывается для извлечения URL-адресов персонажей из каждого эпизода. В нем работает characterURLs.append(randomCharacterURL), который
//                self?.characterURLs.forEach {
//                    self?.getShownCharacter(from: $0)
//                }
//                self?.dispatchGroup.notify(queue: .main) {
//                    self?.nextPageToLoad += 1
//                    self?.episodesArray.append(contentsOf: episodes)
//                    self?.updateSnapshotRequest.send()
//                    self?.stopIndicatorRequest.send()
//                    collection.finishInfiniteScroll()
//                }
//            case .failure(let error): print(error.errorDescription)
//            }
//        }
//    }//Загружает эпизоды для указанных страниц и обновляет пользовательский интерфейс после успешного получения данных.
//    
//    private func getAllCharacterURLs(from episodesArray: [CharacterResponse]) {
//        for episode in episodesArray {
//            let randomCharacterURL = episode.episode.randomElement() ?? ""
//            characterURLs.append(randomCharacterURL)
//        }
//    }//Извлекает URL персонажей из загруженных эпизодов. Для каждого эпизода выбирается случайный URL персонажа.
//    
//    private func getShownCharacter(from urlString: String) {
//        dispatchGroup.enter()//Это сообщает DispatchGroup, что начинается новая асинхронная задача. Увеличивая счетчик группировки, это позволяет отслеживать количество активных задач. В данном случае, это означает, что ожидается завершение асинхронного вызова получения данных о персонаже.
//        networkService.getCharacter(with: urlString) { [weak self] result in
//            switch result {
//            case .success(let character) :
//                self?.showCharacters.append(character)
//                self?.dispatchGroup.leave() //Затем вызывается dispatchGroup.leave(), что уменьшает счетчик задач в группе. Это сигнализирует, что текущая асинхронная задача завершена.
//            case .failure(_): print("EpisodesViewModel: getShownCharacter error")
//            }
//        }
//    }//Загружает информацию о персонаже по его URL и добавляет его в shownCharacters. Использует dispatchGroup для синхронизации асинхронных вызовов.
//    
//}
// 
////использование DispatchGroup позволяет отслеживать все асинхронные вызовы, которые были инициированы. Это актуально в контексте кода, так как персонажи загружаются параллельно из массива characterURLs. В конце, когда все запросы завершены (то есть, когда счетчик возвращается к нулю), можно вызвать общий обработчик, который уведомляет об окончании загрузки, например, обновляет интерфейс.
