//
//  UIView+Extension.swift
//  ouat
//
//  Created by Antique on 6/4/20.
//  Copyright © 2020 Antique. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    
    func addGradientToViewWithCornerRadiusAndShadow(radius:CGFloat,firstColor:UIColor,secondColor:UIColor,locations:[CGFloat]){
        for layer in (self.layer.sublayers ?? []) {
            if let gradientLayer = layer as? CAGradientLayer{
                gradientLayer.removeFromSuperlayer()
            }
        }
        
        
        let gradient = CAGradientLayer()
        var rect = self.bounds
        rect.size.width = UIScreen.main.bounds.width
        gradient.frame = rect
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        gradient.locations = locations as [NSNumber]
        gradient.startPoint = CGPoint.init(x: 0, y: 0)
        gradient.endPoint = CGPoint.init(x: 0, y: 1)
        gradient.cornerRadius = radius
        self.layer.insertSublayer(gradient, at: 0)
    }
}
