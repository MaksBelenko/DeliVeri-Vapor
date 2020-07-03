//
//  UIFontExtensions.swift
//  DeliVeri
//
//  Created by Maksim on 03/07/2020.
//  Copyright © 2020 Maksim. All rights reserved.
//

import UIKit.UIFont

extension UIFont {
    
    static func arialBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Arial-BoldMT", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    static func arial(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Arial", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
