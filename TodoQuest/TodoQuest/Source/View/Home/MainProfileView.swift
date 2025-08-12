//
//  MainProfileView.swift
//  TodoQuest
//
//  Created by 장상경 on 8/8/25.
//

import UIKit
import Then
import SnapKit

final class MainProfileView: UIView {
    
    private let profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .View.profileTint
        $0.backgroundColor = .View.profileBackground
        $0.clipsToBounds = true
        $0.image = UIImage(systemName: "person")
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .SCDream(size: 16, weight: .medium)
        $0.numberOfLines = 1
        $0.textColor = .Label.blackLabel
        $0.textAlignment = .left
        $0.backgroundColor = .clear
    }
    
    private let levelLabel = UILabel().then {
        $0.font = .SCDream(size: 14, weight: .regular)
        $0.numberOfLines = 1
        $0.textColor = .Label.grayLabel
        $0.textAlignment = .left
        $0.backgroundColor = .clear
    }
    
    private let expLabel = UILabel().then {
        $0.font = .SCDream(size: 10, weight: .regular)
        $0.numberOfLines = 1
        $0.textColor = .Label.grayLabel
        $0.textAlignment = .left
        $0.backgroundColor = .clear
    }
    
    private let labelStack = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 4
        $0.alignment = .leading
        $0.backgroundColor = .clear
    }
    
    private let progressView = ProgressView()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
    }
    
    func configProfile(_ profileData: ProfileData) {
        profileImage.image = profileData.image == nil ? profileImage.image : profileData.image
        nameLabel.text = profileData.name
        levelLabel.text = "Lv. \(profileData.level)"
        expLabel.text = "레벨업까지 \(profileData.exp)exp"
        progressView.state = profileData.progress
    }
    
}

// MARK: - UI Setting Method

private extension MainProfileView {
    
    func setupUI() {
        configureSelf()
        setupLayout()
    }
    
    func configureSelf() {
        [profileImage, labelStack].forEach {
            addSubview($0)
        }
        backgroundColor = .View.whiteBody
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .init(width: 0, height: 0)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
    }
    
    func setupLayout() {
        [nameLabel, levelLabel, expLabel, progressView].forEach {
            labelStack.addArrangedSubview($0)
        }
        
        profileImage.snp.makeConstraints {
            $0.size.greaterThanOrEqualTo(100)
            $0.width.lessThanOrEqualTo(profileImage.snp.height)
            $0.top.leading.bottom.equalToSuperview().inset(20)
        }
        
        labelStack.snp.makeConstraints {
            $0.leading.equalTo(profileImage.snp.trailing).offset(20)
            $0.directionalVerticalEdges.equalTo(profileImage).inset(10)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        progressView.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.width.equalToSuperview()
        }
    }
    
}
