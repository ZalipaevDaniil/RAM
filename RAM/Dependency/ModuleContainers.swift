//
//  ModuleContainers.swift
//  RAM
//
//  Created by Aaa on 09.10.2024.
//

import UIKit

final class ModuleContainer{
    private let dependencies : Dependencies
    
    required init(_ dependcies: Dependencies) {
        self.dependencies = dependcies
        
    }
}

//MARK: LaunchVC
extension ModuleContainer {
    func getLaunchView() -> UIViewController {
        return LaunchViewController()
    }
}

//MARK: TabBar Controller
extension ModuleContainer {
    func getTabBarController() -> UIViewController {
        let tabBar = TabBarController()
        let episodesCVC = EpisodesAssambley.configure(dependencies)
        let favoritesCVC = FavoritesAssambley.configure(dependencies)
        
        tabBar.viewControllers = [episodesCVC, favoritesCVC]
        return tabBar
    }
}



//MARK: FetchedEpisodeVC
extension ModuleContainer {
    func getEpisodeCollectionViewController() -> EpisodesCollectionViewController {
        let flowLayout = UICollectionViewFlowLayout()
        let viewModel = EpisodeViewModel(dependencies: dependencies)
        let episodeCVC = EpisodesCollectionViewController(collectionViewLayout: flowLayout)
        episodeCVC.viewModel = viewModel
        
        return episodeCVC
    }
}

//MARK: FetchedFavoritesVC
extension ModuleContainer {
    func getFavoritesCollectionViewController() -> FavoritesCollectionViewController {
        let flowLayout = UICollectionViewFlowLayout()
        let viewModel = EpisodeViewModel(dependencies: dependencies)
        let favCVC = FavoritesCollectionViewController(viewModel: viewModel, collectionViewLayout: flowLayout)
        favCVC.viewModel = viewModel
        
        return favCVC
    }
}

//MARK: FetchedDetailVC
extension ModuleContainer {
    func getDetailsCollectionViewController(_ character: CharacterResponse) -> UIViewController {
        let dependency = Dependencies()
        let viewModel = EpisodesCellViewModel(dependency: dependency, character: character)
        let detailVC = DetailsViewController()
        detailVC.viewModel = viewModel
        return detailVC
    }
}


