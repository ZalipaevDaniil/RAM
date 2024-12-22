//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 21.12.2024.
//

import UIKit

final class FavoritesNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Установка специфичных атрибутов для navBAr
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        navigationBar.barTintColor = .white
        navigationBar.isTranslucent = false
    }

}
