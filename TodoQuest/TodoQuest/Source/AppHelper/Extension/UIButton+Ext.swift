//
//  UIButton+Ext.swift
//  TodoQuest
//
//  Created by 장상경 on 8/7/25.
//

import UIKit

extension UIButton.Configuration {
    
    /// 탭바에서 쓸 공용 버튼 Configuration 스타일
    /// - Parameters:
    ///   - title: 버튼에 넣을 Text
    ///   - image: 버튼에 넣을 Image
    /// - Returns: UIButton.Configuration
    static func tabButtonStyle(_ title: String?, _ image: UIImage?) -> Self {
        var config = self.plain()
        config.image = image
        config.imagePlacement = .top
        config.imagePadding = 4
        
        var attr = AttributedString(title ?? "")
        attr.font = .SCDream(size: 14, weight: .medium)
        attr.foregroundColor = .CustomColors.blueGray
        config.attributedTitle = attr
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .CustomColors.blueGray
        
        return config
    }
    
    static var floatingButtonStyle: Self {
        var config = self.filled()
        config.image = UIImage(systemName: "paintbrush.pointed.fill")
        config.imagePadding = 0
        config.imagePlacement = .all
        config.baseForegroundColor = .View.whiteBody
        config.baseBackgroundColor = .CustomColors.personal
        config.cornerStyle = .capsule
        config.background.strokeColor = .View.whiteBody
        config.background.strokeWidth = 3
        
        return config
    }
    
}
