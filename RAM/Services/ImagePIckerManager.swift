//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 08.12.2024.
//

import Foundation
import UIKit

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageHandler: ((UIImage) -> Void)?
    
    func showImagePickerForGallery(_ viewController: UIViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        viewController.present(imagePicker, animated: true)
    }
    
}
