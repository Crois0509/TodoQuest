//
//  HomeViewController.swift
//  TodoQuest
//
//  Created by 장상경 on 8/8/25.
//

import UIKit
import Then
import SnapKit

final class HomeViewController: UIViewController {
    
    private let profileView = MainProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        profileView.configProfile(.init(image: nil, name: "Admin1234", level: 10, exp: 980, progress: 0.54))
    }
    
}

// MARK: - UI Setting Method

private extension HomeViewController {
    
    func setupUI() {
        configureSelf()
        setupLayout()
    }
    
    func configureSelf() {
        [profileView].forEach {
            view.addSubview($0)
        }
    }
    
    func setupLayout() {
        profileView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview().inset(20)
//            $0.height.equalTo(140)
        }
    }
    
}

@available(iOS 17.0, *)
#Preview {
    HomeViewController()
}
