//
//  RotatingButton.swift
//  keats
//
//  Created by Swamita on 08/05/21.
//

import Foundation
import UIKit.UIView

extension UIView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi / 4)
        rotation.duration = 0.25
        rotation.isCumulative = false
        rotation.repeatCount = 1
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func curvedButtonView(color: String) {
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(named: color)?.cgColor
    }
}
