//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 08.12.2024.
//

import Foundation

class ImageCacheManager : NSCache<NSString, NSData> {
    
    func getImage(
        from urlString: String,
        witch dependencies: Dependencies,
        _ completion: @escaping(Result<NSData, Error>) -> Void ) {
            
            guard let url = URL(string: urlString) else { return }
            
            if let cachedData = self.object(forKey: url.lastPathComponent as NSString) {
                completion(.success(cachedData))
                return
            }
            
            dependencies.networkService.fetchImage(from: urlString) { result in
                switch result {
                case .success(let imageData):
                    self.setObject(NSData(data: imageData), forKey: url.lastPathComponent as NSString)
                    completion(.success(NSData(data: imageData)))
                case .failure(let error) :
                    completion(.failure(error))
            }
        }
    }
}
    

