//
//  LaunchCoordinatorDelegate.swift
//  TodoQuest
//
//  Created by 장상경 on 8/6/25.
//

import Foundation

protocol LaunchCoordinatorDelegate: AnyObject where Self: Coordinator {
    func pushMainViewController()
}
