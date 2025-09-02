//
//  CalendarHeaderView.swift
//  TodoQuest
//
//  Created by 장상경 on 9/2/25.
//

import UIKit
import SnapKit
import Then

final class CalendarHeaderView: UIStackView {
    
    // MARK: - Properties
    
    private let previousImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "chevron.left")
        $0.backgroundColor = .clear
        $0.tintColor = .Label.blackLabel
    }
    
    private let nextImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "chevron.right")
        $0.backgroundColor = .clear
        $0.tintColor = .Label.blackLabel
    }
    
    private let title = UILabel().then {
        $0.font = .SCDream(size: 24, weight: .bold)
        $0.numberOfLines = 1
        $0.textColor = .Label.blackLabel
        $0.textAlignment = .center
        $0.backgroundColor = .clear
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    func configTitle(_ title: String) {
        self.title.text = title
    }
    
}

// MARK: - UI Setting Method

private extension CalendarHeaderView {
    
    func setupUI() {
        axis = .horizontal
        distribution = .fill
        backgroundColor = .clear
        
        [previousImage, title, nextImage].forEach {
            addArrangedSubview($0)
        }
        
        title.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.6).priority(.high)
        }
        
        nextImage.snp.makeConstraints {
            $0.width.equalTo(previousImage)
        }
    }
    
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    CalendarHeaderView()
}
