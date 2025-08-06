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
        let launchCoordinator = LaunchCoordinator(nav: nav)
        launchCoordinator.delegate = self
        launchCoordinator.start()
        
        child.append(launchCoordinator)
    }
    
}

// MARK: - AppCoordinator Delegate Methods

extension AppCoordinator: LaunchCoordinatorDelegate {
    /// Launch에서 Main으로 화면전환을 요청하는 메소드
    func pushMainViewController() {
        let mainCoordinator = MainCoordinator(nav: nav)
        mainCoordinator.start()
        
        child = [mainCoordinator]
    }
}

// MARK: - LaunchCoordinator

final class LaunchCoordinator: Coordinator {
    private let nav: UINavigationController
    weak var delegate: LaunchCoordinatorDelegate?
    
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        let vc = LaunchViewController()
        vc.delegate = delegate
        nav.viewControllers = [vc]
    }
}

// MARK: - MainCoordinator

final class MainCoordinator: Coordinator {
    private let nav: UINavigationController
    
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        let vc = MainViewController()
        nav.viewControllers = [vc]
    }
}
