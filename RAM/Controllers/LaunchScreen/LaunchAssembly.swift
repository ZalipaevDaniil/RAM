//
//  LaunchAssembly.swift
//  RAM
//
//  Created by Aaa on 09.10.2024.
//

import UIKit

final class LaunchAssambley {
    static func configure(_ dependencies: Dependencies) -> UIViewController {
        return dependencies.moduleContainer.getLaunchView()
    }
}
