//
//  UserDefaultService {.swift
//  RAM
//
//  Created by Aaa on 01.09.2024.
//

import Foundation

protocol UserDefaultsServiceProtocol {
    func getFavoriteStatus(forKey: Int) -> Bool
    func setFavoritesStatus(forKey: Int, witch status: Bool)
}

final class UserDefaultsService: UserDefaultsServiceProtocol {
    
    
    private let userDefaults = UserDefaults()
    
    func getFavoriteStatus(forKey: Int) -> Bool {
        userDefaults.bool(forKey: String(forKey))
    }
    
    func setFavoritesStatus(forKey: Int, witch status: Bool) {
        userDefaults.set(status, forKey: String(forKey))
    }
    
}