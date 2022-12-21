//
//  UIView+Extension.swift
//  Voice Chat
//
//  Created by Eymen Varilci on 21.12.2022.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get{
            return cornerRadius
        }
        set{
            self.layer.cornerRadius = newValue
            
        }
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
