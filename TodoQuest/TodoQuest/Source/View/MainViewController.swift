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
    }
    
    func configureSelf() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.titleView = titleLogo
        navigationItem.setRightBarButton(createBarButton(), animated: false)
        
        view.backgroundColor = .CustomColors.mainWhite
    }
    
    func setupLayout() {
        
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
