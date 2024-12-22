//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 26.10.2024.
//
import UIKit

//MARK: Coordinator
protocol Coordinator: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var navigationController: UINavigationController { get set } /// Каждому координатору назначается один навигационный контроллер.
    var childCoordinators: [Coordinator] { get set } /// Массив для отслеживания всех дочерних координаторов. В большинстве случаев этот массив будет содержать только одного дочернего координатора.
    var type: CoordinatorType { get } /// Определяет тип потока (flow type).
    var dependencies: Dependencies {get}
    
    func start()    /// Место для логики, с которой начинается поток.

    func finish()    /// Место для логики, с которой завершается поток: здесь можно очистить всех дочерних координаторов и уведомить родителя, что этот координатор готов к удалению.
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self) ///Проверяет завершил ли координатор работу и передает об этом сигнал в Координатор, который был назначен делегатом(AppCoordinator)
    }
}
//MARK: CoordinatorOutPut

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish (childCoordinator: Coordinator)
} /// Протокол-делегат, который помогает родительскому координатору узнать, когда его дочерний координатор готов завершить свою работу.

//MARK: CoordinatorType

enum CoordinatorType {
    case app, launch, tab
} /// С помощью этой структуры мы можем определить, какие типы потоков могут быть использованы в приложении.

