//
//  UIColor+Ext.swift
//  TodoQuest
//
//  Created by 장상경 on 8/11/25.
//

import UIKit

extension UIColor {
    
    func encode() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
    
    static func decode(from data: Data) -> UIColor? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }
    
}
