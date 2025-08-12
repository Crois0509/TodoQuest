//
//  CustomFont.swift
//  TodoQuest
//
//  Created by 장상경 on 8/8/25.
//

import UIKit

extension UIFont {
    
    static func SCDream(size fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        let familyName = "S-CoreDream-"
        
        var weightString: String
        switch weight {
        case .black:
            weightString = "9Black"
        case .bold:
            weightString = "7ExtraBold"
        case .heavy:
            weightString = "8Heavy"
        case .ultraLight:
            weightString = "2ExtraLight"
        case .light:
            weightString = "3Lihgt"
        case .medium:
            weightString = "5Medium"
        case .regular:
            weightString = "4Regular"
        case .semibold:
            weightString = "6Bold"
        case .thin:
            weightString = "1Thin"
        default:
            weightString = "4Regular"
        }
        
        return UIFont(name: "\(familyName)\(weightString)", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: weight)
    }
    
    static func printAll() {
        familyNames.sorted().forEach { familyName in
            debugPrint("*** \(familyName) ***")
            fontNames(forFamilyName: familyName).sorted().forEach { fontName in
                debugPrint("\(fontName)")
            }
        }
    }
}
