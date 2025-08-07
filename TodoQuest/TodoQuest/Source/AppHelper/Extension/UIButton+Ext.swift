//
//  UIButton+Ext.swift
//  TodoQuest
//
//  Created by 장상경 on 8/7/25.
//

import UIKit

extension UIButton.Configuration {
    
    static func tabButtonStyle(_ title: String, _ image: UIImage?) -> Self {
        var config = Self.plain()
        config.image = image
        config.imagePlacement = .top
        config.imagePadding = 4
        
        var attr = AttributedString(title)
        attr.font = .systemFont(ofSize: 14)
        attr.foregroundColor = .CustomColors.blueGray
        config.attributedTitle = attr
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .CustomColors.blueGray
        
        return config
    }
    
}
