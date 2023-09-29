//
//  TextFieldWithPadding1.swift
//  Ozinshe App
//
//  Created by Мерей Булатова on 26.09.2023.
//

import Foundation
import UIKit

class TextFieldWithPadding1: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 16);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}


