//
//  EpisodesAssambly.swift
//  RAM
//
//  Created by Aaa on 06.09.2024.
//

import Foundation
import UIKit

final class EpisodesAssambley {
    static func configure(_ dependencies: Dependencies) -> UIViewController{
        return dependencies.moduleContainer.getEpisodeCollectionViewController()
    }
}
