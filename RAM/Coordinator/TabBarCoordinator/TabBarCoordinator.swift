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
        let pages: [TabBarPage] = [ .episodes, .favorites ]
            .sorted(by: {$0.pageOrderNumber() < $1.pageOrderNumber()})
        
        let controllers : [UIViewController] = pages.map({getTabController($0)})
        prepareTabBArController(withTabControllers: controllers)
        tabBarController.viewControllers = controllers
        tabBarController.navigationItem.hidesBackButton = true
        navigationController.setViewControllers([tabBarController], animated: true)
        
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
    private func getTabController(_ page: TabBarPage) -> UIViewController {
        
        switch page {
            ///При необходимости: каждый поток панели вкладок может иметь своего собственного координатора.
        case .episodes:
            let viewController = dependencies.moduleContainer.getEpisodeCollectionViewController()
            viewController.detailsViewControllerDelegate = self
            viewController.tabBarItem = UITabBarItem(title: nil, image: page.pageImageValue(), selectedImage: UIImage(named: "homeTabBar.fill"))
            return viewController
        case .favorites:
            let favCVC = dependencies.moduleContainer.getFavoritesCollectionViewController()
            favCVC.detailsControllerDelegate = self
            favCVC.tabBarItem = UITabBarItem(title: nil, image: page.pageImageValue(), selectedImage: UIImage(named: "tappedLike"))
            return favCVC
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
    func didTappedOnCharacter(_ character: CharacterResult, _ dependencies: Dependencies) {
        let detailVC = DetailsAssambley.configure(character, dependencies)
        navigationController.show(detailVC, sender: self)
    }
    
    func didTappedOnFavoritesCharacter(_ character: CharacterResult, _ dependencies: Dependencies) {
//        print("Navigation starts for the character \(character)")
        let detailVC = DetailsAssambley.configure(character, dependencies)
        navigationController.pushViewController(detailVC, animated: true)
    }
}


