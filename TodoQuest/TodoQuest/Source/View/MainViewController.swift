//
//  ViewController.swift
//  TodoQuest
//
//  Created by 장상경 on 8/5/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    
    private let titleLogo = UIImageView().then {
        $0.image = .title
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
    }
    
    private let manager = CoreDataManager()
    
    private let homeVC = HomeViewController()
    private let calendarVC = CalendarViewController()
    private let profileVC = ThirdVC()
    
    private lazy var mainTab = MainTabBarController([homeVC, calendarVC, profileVC])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

}

// MARK: - UI Setting Method

private extension MainViewController {
    
    func setupUI() {
        configureSelf()
        setupChildVC()
        setupReactor()
    }
    
    func configureSelf() {
        let leftButton = createBarButton().then {
            $0.tintColor = .clear
            $0.isEnabled = false
        }
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.titleView = titleLogo
        navigationItem.setRightBarButton(createBarButton(), animated: false)
        navigationItem.setLeftBarButton(leftButton, animated: false)
        
        view.backgroundColor = .Background.background
    }
    
    func setupChildVC() {
        addChild(mainTab)
        view.addSubview(mainTab.view)
        mainTab.view.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        mainTab.didMove(toParent: self)
    }
    
    func createBarButton() -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: nil, action: nil).then {
            $0.tintColor = .Label.blackLabel
        }
    }
    
    func setupReactor() {
        homeVC.reactor = HomeReactor(repo: manager)
        calendarVC.reactor = CalendarReactor(repo: manager)
    }
    
}

// TODO: Test ViewControllers
class ThirdVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
    }
}
