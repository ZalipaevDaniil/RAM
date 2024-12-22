//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 26.10.2024.
//
import Foundation
import UIKit

protocol LaunchCoordinatorProtocol: Coordinator {
    func showLaunchViewController()
}

class LaunchCoordinator : LaunchCoordinatorProtocol {
    var dependencies: Dependencies
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .launch }
    weak var finishDelegate: (any CoordinatorFinishDelegate)?
    
    init(_ navigationController: UINavigationController, _ dependencies: Dependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        showLaunchViewController()
    }
    
    deinit {
        print("LaunchCoordinator deinit")
    }
    
    
    func showLaunchViewController() {
        let launchVC = dependencies.moduleContainer.getLaunchView()
        navigationController.setViewControllers([launchVC], animated: true)
        
        (launchVC as? LaunchViewController)?.didSendEventClosure = { [weak self] event in
            switch event {
            case .launchComplete:
                self?.finish() //Передает данные в finishDelegate AppCoordinator(a) координатор LaunchCoordinaor, и там уже вызывается функция coordinatorDidFinish
            }
            
        }
    }
    
}
