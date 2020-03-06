//
//  CALayer+GDExtension.swift
//  ColorGradientlayer
//
//  Created by CQSC  on 2017/10/30.
//  Copyright © 2017年 guoda. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    
    func addDefineLayer(_ frame:CGRect) {
        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [layerColor.cgColor,mainColor.cgColor]
           gradientLayer.colors = [layerColor.cgColor,layerColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x:1.0, y:0)
        gradientLayer.frame = frame
        addSublayer(gradientLayer)
    }
}

