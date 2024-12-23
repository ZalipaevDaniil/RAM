//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 25.10.2024.
//

import UIKit


protocol AppCoordinatorProtocol: Coordinator {
    func showLaunchFlow()
    func showMAinFlow()
}

final class AppCoordinator: AppCoordinatorProtocol {
    
    //MARK: Weak Properties
    weak var finishDelegate: CoordinatorFinishDelegate? = nil
    
    //MARK: Public Properties
    var navigationController: UINavigationController
    var childCoordinators : [Coordinator] = []
    var type: CoordinatorType { .app }
    var dependencies: Dependencies
    
    init(_ navigationController: UINavigationController, _ dependencies: Dependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        showLaunchFlow()
    }
    
    func showLaunchFlow() {
        let launchCoordinator = LaunchCoordinator(navigationController, dependencies)
        launchCoordinator.finishDelegate = self //Ссылается на AppCoordinator, т.е данные из LaunchCoordinator будут поступать в AppCoordinator
        childCoordinators.append(launchCoordinator)
        launchCoordinator.start()
    }
    
    func showMAinFlow() {
        let tabBarCoordinator = TabBarCoordinator(navigationController, dependencies)
        tabBarCoordinator.finishDelegate = self
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
    
}

extension AppCoordinator : CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })//Создает массив в котором все координаторы не равны завершившемуся childCoordinator, соответственно удаляет тот, который соответствует
        
        if childCoordinator.type == .launch {showMAinFlow()}
    }
}
