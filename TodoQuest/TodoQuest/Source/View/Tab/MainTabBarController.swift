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
    
    private var viewControllers: [UIViewController] // 각 탭별 ViewController
    
    private let selectedTabIndex = BehaviorRelay<Int>(value: 0)
    private var disposeBag = DisposeBag()
    
    private let tabStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.backgroundColor = .clear
    }
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .CustomColors.lightGray
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.masksToBounds = false
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = .init(width: 0, height: -2)
        $0.layer.shadowRadius = 6
        $0.layer.shadowOpacity = 0.3
    }
    
    init(_ viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
        
        // ViewControllers 초기 설정
        // 0번째 View 외에 alpha 값을 0으로 설정 -> 부드러운 애니메이션을 연출을 위해
        self.viewControllers.enumerated()
            .filter { $0.offset != 0 }
            .forEach { $0.element.view.alpha = 0 }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        backgroundView.layer.shadowPath = .init(rect: backgroundView.bounds, transform: nil)
    }
    
}

// MARK: - UI Setting Method

private extension MainTabBarController {
    
    func setupUI() {
        setupTabBar()
        configureSelf()
        setupLayout()
        setupChildVC(0)
        bind()
    }
    
    func configureSelf() {
        view.backgroundColor = .clear
        [backgroundView, tabStackView].forEach {
            view.addSubview($0)
        }
    }
    
    func setupLayout() {
        backgroundView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        tabStackView.snp.makeConstraints {
            $0.top.equalTo(backgroundView).offset(8)
            $0.directionalHorizontalEdges.equalTo(backgroundView).inset(20)
        }
    }
    
    /// 현재 탭 바에 표시될 ChildViewController 설정
    /// - Parameter index: Child ViewController Index
    func setupChildVC(_ index: Int) {
        let vc = viewControllers[index]
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        vc.didMove(toParent: self)
        view.bringSubviewToFront(backgroundView)
        view.bringSubviewToFront(tabStackView)
    }
    
    func setupTabBar() {
        for (index, tab) in TabBarItems.allCases.enumerated() {
            let button = UIButton(configuration: .tabButtonStyle(tab.title, tab.image))
            button.tag = index
            tabStackView.addArrangedSubview(button)
        }
    }
    
    /// 현재 화면에 표시되는 뷰를 변경하는 메소드
    /// - Parameter index: 변경할 인덱스
    func transitionToViewController(at index: Int) {
        guard index < viewControllers.count else { return }
        
        let fromVC = children.first
        let toVC = viewControllers[index]
        
        guard fromVC !== toVC else { return }
        
        fromVC?.willMove(toParent: nil)
        setupChildVC(index)
        
        UIView.animate(withDuration: 0.3) {
            fromVC?.view.alpha = 0
            toVC.view.alpha = 1
        } completion: { _ in
            fromVC?.view.removeFromSuperview()
            fromVC?.removeFromParent()
        }
    }
    
    /// 버튼의 색상을 변경하는 메소드
    /// - Parameter index: 현재 선택된 버튼의 인덱스
    func updateButtonTintColor(selected index: Int) {
        let buttons = tabStackView.arrangedSubviews.compactMap { $0 as? UIButton }
        
        buttons.forEach { button in
            if button.tag == index {
                button.configuration?.baseForegroundColor = .CustomColors.personal
            } else {
                button.configuration?.baseForegroundColor = .CustomColors.blueGray
            }
        }
    }
    
    func bind() {
        let buttons = tabStackView.arrangedSubviews.compactMap { $0 as? UIButton }
        
        buttons.forEach { [weak self] button in
            guard let self else { return }
            button.rx.tap
                .map { button.tag }
                .throttle(.seconds(1), latest: false, scheduler: MainScheduler())
                .bind(to: self.selectedTabIndex)
                .disposed(by: disposeBag)
        }
        
        selectedTabIndex
            .withUnretained(self)
            .asSignal(onErrorSignalWith: .empty())
            .emit { owner, index in
                owner.transitionToViewController(at: index)
                owner.updateButtonTintColor(selected: index)
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - TabBar에서 사용할 아이템 목록

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
