//
//  Coordinator.swift
//  TodoQuest
//
//  Created by 장상경 on 8/6/25.
//

import UIKit

/// Coordinator Protocol
protocol Coordinator: AnyObject {
    func start()
}

// MARK: - AppCoordinator

final class AppCoordinator: Coordinator {
    private let nav: UINavigationController
    private var child: [Coordinator] = []
    
    init(_ nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        let vc = MainViewController()
        nav.viewControllers = [vc]
    }
    
}

// MARK: -
