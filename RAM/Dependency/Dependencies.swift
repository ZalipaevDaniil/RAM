//
//  Dependencies.swift
//  RickandMorty
//
//  Created by Aaa on 26.08.2024.
//

import Foundation

protocol DependenciesProtocol {
    var networkService: NetworkServiceProtocol { get }
    var userDefaultService: UserDefaultsServiceProtocol { get }
    var imageCacheManager: ImageCacheManager { get }
    var moduleContainer : ModuleContainer {get}
}

final class Dependencies: DependenciesProtocol{
    lazy var moduleContainer : ModuleContainer = ModuleContainer(self)
    lazy var networkService: NetworkServiceProtocol = NetworkService()
    lazy var userDefaultService: UserDefaultsServiceProtocol = UserDefaultsService()
    lazy var imageCacheManager: ImageCacheManager = ImageCacheManager()
    
}

 

