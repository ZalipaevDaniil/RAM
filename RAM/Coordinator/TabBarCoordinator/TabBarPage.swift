//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 27.10.2024.
//
import UIKit
enum TabBarPage {
    case episodes
    case favorites
    
    init?(_ index: Int) {
        switch index {
        case 0:
            self = .episodes
        case 1:
            self = .favorites
        default:
            return nil
        }
    }
    
    
    func pageOrderNumber() -> Int {
        switch self {
        case .episodes:
            return 0
        case .favorites :
            return 1
        }
    }
    
    func pageImageValue() -> UIImage? {
        var imageName: String
        switch self {
        case .episodes:
            imageName = "homeTabBar"
        case .favorites:
            imageName = "likeImage"
        }
        
        guard let image = UIImage(named: imageName) else {
            return nil
        }
        
        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 30, height: 30))
        return resizedImage.withRenderingMode(.alwaysOriginal
        )
    }
    
}
extension TabBarPage {
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let render = UIGraphicsImageRenderer(size: targetSize)
        return render.image {_ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    }


    


