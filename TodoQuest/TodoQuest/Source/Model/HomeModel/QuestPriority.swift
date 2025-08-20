//
//  QuestPriority.swift
//  TodoQuest
//
//  Created by 장상경 on 8/11/25.
//

import UIKit

enum QuestPriority: String, CaseIterable {
    case P0, P1, P2, P3, P4
    
    var priorityColor: UIColor? {
        switch self {
        case .P0:
            if UserDefaults.standard.object(forKey: "P0") == nil {
                let color = UIColor(red: 197/255, green: 28/255, blue: 47/255, alpha: 1)
                UserDefaults.standard.set(color.encode(), forKey: "P0")
                return color
                
            } else if let savedData = UserDefaults.standard.data(forKey: "P0"),
                      let decodedColor = UIColor.decode(from: savedData) {
                return decodedColor
                
            } else {
                return nil
            }
        case .P1:
            if UserDefaults.standard.object(forKey: "P1") == nil {
                let color = UIColor(red: 253/255, green: 90/255, blue: 94/255, alpha: 1)
                UserDefaults.standard.set(color.encode(), forKey: "P1")
                return color
                
            } else if let savedData = UserDefaults.standard.data(forKey: "P1"),
                      let decodedColor = UIColor.decode(from: savedData) {
                return decodedColor
                
            } else {
                return nil
            }
        case .P2:
            if UserDefaults.standard.object(forKey: "P2") == nil {
                let color = UIColor(red: 255/255, green: 129/255, blue: 126/255, alpha: 1)
                UserDefaults.standard.set(color.encode(), forKey: "P2")
                return color
                
            } else if let savedData = UserDefaults.standard.data(forKey: "P2"),
                      let decodedColor = UIColor.decode(from: savedData) {
                return decodedColor
                
            } else {
                return nil
            }
        case .P3:
            if UserDefaults.standard.object(forKey: "P3") == nil {
                let color = UIColor(red: 255/255, green: 181/255, blue: 176/255, alpha: 1)
                UserDefaults.standard.set(color.encode(), forKey: "P3")
                return color
                
            } else if let savedData = UserDefaults.standard.data(forKey: "P3"),
                      let decodedColor = UIColor.decode(from: savedData) {
                return decodedColor
                
            } else {
                return nil
            }
        case .P4:
            if UserDefaults.standard.object(forKey: "P4") == nil {
                let color = UIColor(red: 255/255, green: 228/255, blue: 226/255, alpha: 1)
                UserDefaults.standard.set(color.encode(), forKey: "P4")
                return color
                
            } else if let savedData = UserDefaults.standard.data(forKey: "P4"),
                      let decodedColor = UIColor.decode(from: savedData) {
                return decodedColor
                
            } else {
                return nil
            }
        }
    }
}

