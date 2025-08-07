//
//  MainTabBarController.swift
//  TodoQuest
//
//  Created by 장상경 on 8/7/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class MainTabBarController: UIViewController {
}
extension MainTabBarController {
    enum TabBarItems: CaseIterable {
        case home, calendar, myPage
        
        var title: String {
            switch self {
            case .home:
                return "홈"
            case .calendar:
                return "달력"
            case .myPage:
                return "내 정보"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .home:
                return UIImage(systemName: "house")
            case .calendar:
                return UIImage(systemName: "calendar")
            case .myPage:
                return UIImage(systemName: "person.fill")
            }
        }
    }
}
