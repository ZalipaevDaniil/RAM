//
//  SceneDelegate.swift
//  RickandMorty
//
//  Created by Aaa on 26.08.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var dependencies: Dependencies?
    
    let userDefaultService = UserDefaultsService()
    
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let navController = UINavigationController()
        dependencies = Dependencies()
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        //userDefaultService.clearStoredCharacters()
        if let dependencies = dependencies {
            appCoordinator = AppCoordinator(navController, dependencies)
            appCoordinator?.start()
        } else {
            fatalError("Dependencies not initialization")
        }

    }
}
