//
//  LaunchViewController.swift
//  TodoQuest
//
//  Created by 장상경 on 8/6/25.
//

import UIKit
import Then
import SnapKit
import Lottie
import RxSwift
import RxCocoa

final class LaunchViewController: UIViewController {
    
    weak var delegate: LaunchCoordinatorDelegate?
    private var disposeBag = DisposeBag()
    
    @UserDefaultsWrapper(key: "isGuestMode", defaultValue: false)
    private var guestMode: Bool
    
    @UserDefaultsWrapper(key: "isLogin", defaultValue: false)
    private var isLogin: Bool
    
    private let lottie = LottieAnimationView(name: "todoquest").then {
        $0.loopMode = .playOnce
        $0.animationSpeed = 0.8
    }
    
    private let guestButton = UIButton().then {
        $0.setTitle("로그인 없이 이용", for: .normal)
        $0.setTitleColor(.CustomColors.mainWhite, for: .normal)
        $0.backgroundColor = .CustomColors.mainBlack
        $0.titleLabel?.font = .SCDream(size: 24, weight: .bold)
        $0.layer.cornerRadius = 8
        $0.alpha = 0
    }
    
    private let appleButton = UIButton().then {
        $0.setTitle("Sign in with Apple", for: .normal)
        $0.setTitleColor(.CustomColors.mainBlack, for: .normal)
        $0.backgroundColor = .CustomColors.mainWhite
        $0.titleLabel?.font = .SCDream(size: 24, weight: .bold)
        $0.layer.cornerRadius = 8
        $0.alpha = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        playLottie()
    }
}

// MARK: - UI Setting Method

private extension LaunchViewController {
    
    func setupUI() {
        configureSelf()
        setupLayout()
        bind()
    }
    
    func configureSelf() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .CustomColors.personal
        [lottie, guestButton, appleButton].forEach {
            view.addSubview($0)
        }
    }
    
    func setupLayout() {
        lottie.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview().inset(40)
        }
        
        guestButton.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
            $0.centerY.equalToSuperview().offset(200)
        }
        
        appleButton.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalTo(guestButton)
            $0.height.equalTo(guestButton)
            $0.top.equalTo(guestButton.snp.bottom).offset(16)
        }
    }
    
    func hideViewAnimation() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.view.backgroundColor = .Background.background
            self?.lottie.alpha = 0
            self?.guestButton.alpha = 0
            self?.appleButton.alpha = 0
        }) { _ in
            self.delegate?.pushMainViewController()
        }
    }
    
    func playLottie() {
        lottie.play { [weak self] _ in
            guard let self else { return }
            
            if self.guestMode || self.isLogin {
                self.hideViewAnimation()
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.lottie.frame.origin.y -= 150
                    self.guestButton.alpha = 1
                    self.appleButton.alpha = 1
                }
            }
        }
    }
    
    func bind() {
        guestButton.rx.tap
            .withUnretained(self)
            .asSignal(onErrorSignalWith: .empty())
            .emit { owner, _ in
                owner.guestMode = true
                owner.hideViewAnimation()
            }
            .disposed(by: disposeBag)
    }
}
