//
//  NetworkService.swift
//  RAM
//
//  Created by Aaa on 01.09.2024.
//

import UIKit

//protocol INetworkServicee {
//    func getAllEpisodes(forPage page: Int, _ completion: @escaping (Result<EpisodesResponse, NetworkError>) -> Void)
//    //Этот метод запрашивает все эпизоды для определенной страницы. Он принимает номер страницы и замыкание в качестве параметров.
//    
//    func getCharacter(with urlString: String, completion: @escaping (Result<CharacterResponse, NetworkError>) -> Void) 
//    //Метод делает запрос на получение информации о персонаже по URL-строке.
//    
//    func getImage(with characterID: Int, for image: UIImageView) 
//    //Этот метод используется для загрузки изображения персонажа по идентификатору (characterID) и отображения его в UIImageView. Так как метод не использует замыкание для обработки результата, он не возвращает результат, а, скорее, выполняет действия сразу.
//    
//    func getCertainEpisodes(withID id: [Int], _ completion: @escaping (Result<[DetailEpisode], NetworkError>) -> Void) 
//    // Метод запрашивает определенные эпизоды по массиву идентификаторов (id).
//    
//    func getOneEpisode(withID id: Int, _ completion: @escaping(Result<DetailEpisode, NetworkError>) -> Void) 
//    //Этот метод позволяет запрашивать один эпизод по его идентификатору.
//    
//    func getFilteredEpisodes(for serie: String, sortedE: SortedEpisodes, _ completion:  @escaping (Result<EpisodesResponse, NetworkError>) -> Void)
//    //Метод позволяет запрашивать эпизоды, отфильтрованные по определенной серии (serie).
//    
//}
////Протокол INetworkService предоставляется типам, которые реализуют данный интерфейс, и позволяет вам отслеживать, как будут обрабатываться запросы к API и как будут обрабатываться ошибки. Например, вы создаете класс, который соответствует этому протоколу, и реализуете все перечисленные функции с необходимой логикой сетевых запросов. Таким образом, вы можете легко заменять реализацию сетевых запросов или тестировать их, не меняя остальную часть приложения.
////
////Использование замыканий позволяет вам обрабатывать результаты асинхронно, что важно для сетевых операций, которые могут занять некоторое время. Вместо блокирования основного потока выполнения, уведомление о завершении (через замыкание) позволяет взаимодействовать с пользователем.
//
//final class NetworkService : INetworkService {
//    
//    //MARK: Properties
//    private var imagesCache = NSCache<NSString, UIImage>()
//    
//    //MARK: Interface methods
//    func getAllEpisodes(forPage page: Int, _ completion: @escaping (Result<EpisodesResponse, NetworkError>) -> Void) {
//        guard page <= 3, page >= 1 else {return}
//        URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://rickandmortyapi.com/api/episode?page=\(page)")!)) { data,_,error in
//            if let error {
//                completion(.failure(NetworkError.requestError(error)))
//                print("In function NetworkService. \(#function)")
//            }
//            guard let data else {
//                completion(.failure(NetworkError.emptyData))
//                print("In function NetworkService. \(#function)")
//                return
//            }
//            do {
//                let response = try
//                JSONDecoder().decode(EpisodesResponse.self, from: data)
//                completion(.success(response))
//            } catch {
//                completion(.failure(NetworkError.decodingError(error)))
//                print("In function NetworkService. \(#function)")
//            }
//        }.resume()//В Swift, метод resume() используется для запуска или продолжения выполнения задачи, созданной с помощью URLSession. Когда вы создаете задачу, например, с помощью dataTask(with:), она находится в состоянии "приостановлена". Это означает, что задача не будет выполняться, пока вы явно не вызовете resume().
//    }
//    
//    func getCharacter(with urlString: String, completion: @escaping (Result<CharacterResponse, NetworkError>) -> Void) {
//        URLSession.shared.dataTask(with: URLRequest(url: URL(string: urlString)!)) { data,_,error in
//            if let error {
//                completion(.failure(NetworkError.requestError(error)))
//                print("In function NetworkService. \(#function)")
//            }
//            
//            guard let data else {
//                completion(.failure(NetworkError.emptyData))
//                print("In function NetworkService \(#function)")
//                return
//            }
//            do {
//                let response = try
//                JSONDecoder().decode(CharacterResponse.self, from: data)
//                completion(.success(response))
//            } catch {
//                completion(.failure(NetworkError.decodingError(error)))
//                print("In function NetworkService \(#function)")
//            }
//        }.resume()
//    }
//    
//    func getImage(with personID: Int, for image: UIImageView) {
//        guard let url = URL(string: "https://rickandmortyapi.com/api/character/avatar/\(personID).jpeg") else {return}
//        
//        if let cachedImage = imagesCache.object(forKey: url.absoluteString as NSString) {
//            DispatchQueue.main.async {
//                image.image = cachedImage
//            }//Здесь происходит попытка получить кэшированное изображение из imagesCache (кэша изображений) по созданному URL. Если изображение найдется в кэше, оно будет присвоено переменной cachedImage.
//            //Если изображение найдено в кэше, оно будет отображено в UIImageView. Все обновления пользовательского интерфейса должны выполняться на главном потоке, поэтому используется DispatchQueue.main.async.
//                //DispatchQueue.main.async: этот код запрашивает выполнение определенного кода в основной (main) поток. Основной поток — это тот поток, который управляет пользовательским интерфейсом приложения. Все изменения пользовательского интерфейса должны выполняться именно в этом потоке, иначе могут возникнуть ошибки или некорректное отображение.
//        }
//        
//        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
//        //cachePolicy: Это параметр, который определяет, как запрос будет работать с кэшированными данными. .returnCacheDataElseLoad — это одна из политик кэширования. Она означает следующее: 1)Сначала будет возвращено кэшированное значение (если оно существует). 2)Если кэшированных данных нет, будет выполнен запрос к серверу для получения данных.
//        URLSession.shared.dataTask(with: request) {data,_,error in
//            if let error {
//                print("\(NetworkError.imageFetchingError) in function NetworkService. \(#function)")
//            }
//            guard let data else {
//                print("\(NetworkError.emptyData) in function NetworkService \(#function)")
//                return
//            }
//            
//            guard let receivedImage = UIImage(data: data) else {
//                print("\(NetworkError.cannotConvertImage) in function NetworkService. \(#function)")
//                return
//            }
//            self.imagesCache.setObject(receivedImage, forKey: url.absoluteString as NSString)
//            
//            DispatchQueue.main.async {
//                image.image = receivedImage
//            }
//        }
//    }
//    
//    func getCertainEpisodes(withID id: [Int], _ completion: @escaping (Result<[DetailEpisode], NetworkError>) -> Void) {
//        
//        guard let url = makeURLForSeveralEpisodesRequest(forIDs: id) else {
//            completion(.failure(NetworkError.badURL))
//            return
//        }
//        URLSession.shared.dataTask(with: URLRequest(url: url)) {data,_,error in
//            if let error {
//                completion(.failure(NetworkError.requestError(error)))
//                print("In function NetworkService \(#function)")
//            }
//            
//            guard let data else{
//                completion(.failure(NetworkError.emptyData))
//                print("In function NetworkService \(#function)")
//                return
//            }
//            
//            do {
//                let response = try
//                JSONDecoder().decode([DetailEpisode].self, from: data)
//                completion(.success(response))
//            } catch {
//                completion(.failure(NetworkError.decodingError(error)))
//                print("In function NetworkService. \(#function)")
//            }
//            
//        }.resume()
//    }
//    
//    func getOneEpisode(withID id: Int, _ completion: @escaping (Result<DetailEpisode, NetworkError>) -> Void) {
//        
//        guard let url = makeURLForSeveralEpisodesRequest(forIDs: [id]) else {
//            completion(.failure(NetworkError.badURL))
//            return
//        }
//        
//        URLSession.shared.dataTask(with: URLRequest(url: url)) { data,_,error in
//            if let error {
//                completion(.failure(NetworkError.requestError(error)))
//                print("In finction NetworkService\(#function)")
//            }
//            
//            guard let data else {
//                completion(.failure(NetworkError.emptyData))
//                print("In function NetworkService \(#function)")
//                return
//            }
//            
//            do {
//                let response = try
//                JSONDecoder().decode(DetailEpisode.self, from: data) //Декодирование данных из API в Swift происходит посредством класса JSONDecoder, который переводит JSON-ответ от сервера в соответствующие структуры, соответствующие вашему коду.
//                completion(.success(response))
//            } catch {
//                completion(.failure(NetworkError.decodingError(error)))
//                print("In function NetworkService\(#function)")
//            }
//            
//        }.resume()
//        
//    }
//    
//    func getFilteredEpisodes(for serie : String, sortedE: SortedEpisodes, _ completion: @escaping (Result<EpisodesResponse, NetworkError>) -> Void) {
//        
//        guard let url = URL(string:"https://rickandmortyapi.com/api/episode/?episode=\(serie)") else {
//            completion(.failure(NetworkError.badURL))
//            return
//        }
//        URLSession.shared.dataTask(with: URLRequest(url: url)) {data,_,error in
//            if let error {
//                completion(.failure(NetworkError.requestError(error)))
//                print("In function NetworkService\(#function)")
//            }
//            
//            guard let data else {
//                completion(.failure(NetworkError.emptyData))
//                print("In function NetworkService\(#function)")
//                return
//            }
//            do {
//                let response = try JSONDecoder().decode(EpisodesResponse.self, from: data)
//                
//                var sortedResults: [DetailEpisode]
//                switch sortedE {
//                case .ascending :
//                    sortedResults = response.results.sorted{ $0.episode < $1.episode}
//                case .descending:
//                    sortedResults = response.results.sorted{ $0.episode > $1.episode}
//                }
//                let sortedResponse = EpisodesResponse(info: response.info, results: sortedResults)
//                completion(.success(sortedResponse))
//            } catch {
//                completion(.failure(NetworkError.decodingError(error)))
//                print("In function NetworkService\(#function)")
//            }
//        }
//    }
//    
//    private func makeURLForSeveralEpisodesRequest(forIDs ids: [Int]) -> URL? {
//        guard !ids.isEmpty else {return nil}
//        var baseURLString = "https://rickandmortyapi.com/api/episode/"
//        ids.forEach {
//            baseURLString += "\($0)"
//        }
////        baseURLString.removeLast()
//        let url = URL(string: baseURLString)
//        return url
//    }
//}
