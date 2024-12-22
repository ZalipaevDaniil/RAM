//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 24.11.2024.
//

import UIKit

final class FavoritesAssambley {
    static func configure(_ dependencies: Dependencies) -> UIViewController {
        return dependencies.moduleContainer.getFavoritesCollectionViewController()
    }
}
