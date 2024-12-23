//
//  TabBarCoordinator.swift
//  RAM
//
//  Created by Aaa on 02.09.2024.
//

import Foundation
import UIKit
import Combine
protocol TabBarCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController? { get set }
    
    func selectPage(_ page: TabBarPage)
    
    func setSelectedIndex(_ index: Int)
    
    func currentPage() -> TabBarPage?
}

final class TabBarCoordinator: NSObject, TabBarCoordinatorProtocol {
    
    weak var finishDelegate: (any CoordinatorFinishDelegate)?
    
    var navigationController: UINavigationController
    var tabBarController: UITabBarController?
    var favoritesNavigationController: FavoritesNavigationController?
    var childCoordinators: [any Coordinator] = []
    var dependencies: Dependencies
    var type: CoordinatorType { .tab }
    
    init(_ navigationController: UINavigationController, _ dependencies: Dependencies) {
        self.dependencies = dependencies
        self.navigationController = navigationController
        self.tabBarController = dependencies.moduleContainer.getTabBarController() as? UITabBarController
    }
    
    func start() {
        guard let tabBarController = tabBarController else {return}
        navigationController.setViewControllers([tabBarController], animated: true)
       
        let pages: [TabBarPage] = [ .episodes, .favorites ]
            .sorted(by: {$0.pageOrderNumber() < $1.pageOrderNumber()})
        let controllers : [UINavigationController] = pages.map({getTabController($0)})
        
        prepareTabBArController(withTabControllers: controllers)
    }
    
    deinit {
        print("TabCoordinator deinit")
    }
    
    func selectPage(_ page: TabBarPage) {
        tabBarController?.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage(index) else {return}
        tabBarController?.selectedIndex = page.pageOrderNumber()
    }
    
    func currentPage() -> TabBarPage? {
        guard let selectedIndex = tabBarController?.selectedIndex else {
            return nil
        }
        return TabBarPage(selectedIndex)
    }
    
    
    //MARK: Private Methods
    private func prepareTabBArController(withTabControllers tabControllers: [UIViewController]) {
        ///Установить делегата для UITabBarController
        tabBarController?.delegate = self
        ///Назначить контроллеры страницы
        tabBarController?.setViewControllers(tabControllers, animated: true)
        ///Задать индекс
        tabBarController?.selectedIndex = TabBarPage.episodes.pageOrderNumber()
        ///Задать стиль, полупрозрачный или нет
        tabBarController?.tabBar.isTranslucent = true
    }
    
    //Controller coordination
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        
        
        
        switch page {
            ///При необходимости: каждый поток панели вкладок может иметь своего собственного координатора.
        case .episodes:
            let viewController = dependencies.moduleContainer.getEpisodeCollectionViewController()
            viewController.detailsViewControllerDelegate = self
            let navController = UINavigationController(rootViewController: viewController)
            navController.tabBarItem = UITabBarItem(title: nil, image: page.pageImageValue(), tag: page.pageOrderNumber())
            return navController
        case .favorites:
            let favCVC = dependencies.moduleContainer.getFavoritesCollectionViewController()
            favCVC.detailsControllerDelegate = self
            favCVC.tabBarItem = UITabBarItem(title: nil, image: page.pageImageValue(), tag: page.pageOrderNumber())
            let navigationController = FavoritesNavigationController(rootViewController: favCVC)
            
            return navigationController
        }
    }
}

extension TabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if let selectIndex = tabBarController.viewControllers?.firstIndex(of: viewController),
           let page = TabBarPage(selectIndex) {
            print("TabBArController selected page \(page)")
        }
        
        
    }
}

//MARK: Detail View Controller Delegate
extension TabBarCoordinator : DetailViewControllerDelegate {
    func didTappedOnCharacter(_ character: CharacterResponse, _ dependencies: Dependencies) {
        let detailVC = DetailsAssambley.configure(character, dependencies)
        navigationController.show(detailVC, sender: self)
    }
    
    func didTappedOnFavoritesCharacter(_ character: CharacterResponse, _ dependencies: Dependencies) {
        print("Navigation starts for the character \(character)")
        guard let favoritesNavController = self.favoritesNavigationController else {
            print(" favoritesNAVController equality nil")
            return }
        let detailVC = DetailsAssambley.configure(character, dependencies)
        favoritesNavController.show(detailVC, sender: self)
    }
    
    
}


