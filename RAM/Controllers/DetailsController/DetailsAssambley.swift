//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 24.11.2024.
//

import UIKit

final class DetailsAssambley {
    static func configure(_ character: CharacterResponse,_ dependencies: Dependencies) -> UIViewController {
        return dependencies.moduleContainer.getDetailsCollectionViewController(character)
    }
}
