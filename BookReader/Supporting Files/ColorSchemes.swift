//
//  ColorSchemes.swift
//  MangaMonster
//
//  Created by Mahesh Jindal on 27/01/19.
//  Copyright © 2019 MaheshJindal. All rights reserved.
//

import Foundation
import UIKit


extension UIButton {
    func setGradient(color1:UIColor, color2:UIColor){
       self.layer.cornerRadius = self.frame.size.height/6
        self.layer.masksToBounds  = true
        self.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        self.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.addGradientToBackground(color1: color1, color2: color2)
    }
    
}

extension UIView {
    func addGradientToBackground(color1:UIColor, color2:UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [color1.cgColor,color2.cgColor]
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
}
