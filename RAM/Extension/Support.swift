//
//  Support.swift
//  RickandMorty
//
//  Created by Aaa on 28.08.2024.
//

import UIKit

enum Support {
    static let isIphoneFifteen: Bool = {
        return UIDevice.current.userInterfaceIdiom == .phone && max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 844
    }()
}
