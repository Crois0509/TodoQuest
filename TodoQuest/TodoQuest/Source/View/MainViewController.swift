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
    
    private let mainTab = MainTabBarController([FirstVC(), SecondVC(), ThirdVC()])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

}

// MARK: - UI Setting Method

private extension MainViewController {
    
    func setupUI() {
        configureSelf()
        setupLayout()
        setupChildVC()
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
        
        view.backgroundColor = .CustomColors.mainWhite
    }
    
    func setupLayout() {
        
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
            $0.tintColor = .CustomColors.mainBlack
        }
    }
    
}

// TODO: Test ViewControllers
class FirstVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}

class SecondVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}

class ThirdVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
    }
}
