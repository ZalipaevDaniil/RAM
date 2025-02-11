//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 18.11.2024.
//

import Foundation
import UIKit

protocol NetworkServiceProtocol {
    
    func fetch<T:Decodable>(_ type:T.Type, from url: String, completion: @escaping(Result<T, NetworkError>) -> Void)
    func fetchImage(from url: String, completion: @escaping (Result<Data, NetworkError>) -> Void )
    
}

final class NetworkService: NetworkServiceProtocol {
    
    //MARK: Private Properties
    private var currentPage = 1
    private var isFetchingData = false //в данный момент данные не загружаются.
    private let imageCache = NSCache<NSString, UIImage>()
    
    
    func fetch<T:Decodable>(_ type:T.Type, from url: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL (string: url) else { //проверяте, что  URL верный
            completion(.failure(NetworkError.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) {data, response, error in
            guard let data = data else { //если данные отсутствуют
                completion(.failure(NetworkError.emptyData))
                return
            }
            
            do { //если данные есть ->
                let type = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(type))
                }
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
    func fetchImage(from url: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {// проверяет, что URL верный
            completion (.failure(.badURL))
            return
        }
        
        DispatchQueue.global().async { // скачивает на глобальной очереди не блокируя основной поток
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.emptyData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
        
    }
}
