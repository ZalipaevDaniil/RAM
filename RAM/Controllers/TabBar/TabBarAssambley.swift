//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 25.11.2024.
//

import UIKit

final class TabBarAssambley {
    func configure(_ dependencies: Dependencies) -> UIViewController {
        return dependencies.moduleContainer.getTabBarController()
    }
}
