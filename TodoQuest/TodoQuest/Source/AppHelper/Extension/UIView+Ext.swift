//
//  UIView+Ext.swift
//  TodoQuest
//
//  Created by 장상경 on 8/12/25.
//

import UIKit

extension UIView {
    
    func addBottomBorderWithShapeLayer(with color: UIColor, and thickness: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineWidth = thickness
        borderLayer.fillColor = UIColor.clear.cgColor
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        borderLayer.path = path.cgPath
        self.layer.addSublayer(borderLayer)
    }
    
    var shadowPath: CGPath {
        return UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }
    
}
