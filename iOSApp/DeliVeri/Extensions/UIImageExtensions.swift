//
//  UIImageExtensions.swift
//  ReceiptsSorted
//
//  Created by Maksim on 17/05/2020.
//  Copyright © 2020 Maksim. All rights reserved.
//

import UIKit

extension UIImage {
    /**
     Rounds corners of UIImage
     - Parameter radius: Radius of corner smoothing
     */
    func roundCorners(proportion: CGFloat) -> UIImage {
        let minValue = min(self.size.width, self.size.height)
        let radius = minValue/proportion
        
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}
