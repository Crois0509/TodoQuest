//
//  CalendarHeaderView.swift
//  TodoQuest
//
//  Created by 장상경 on 9/2/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class CalendarHeaderView: UIStackView {
    
    fileprivate let previousTapped = PublishRelay<Void>()
    fileprivate let nextTapped = PublishRelay<Void>()
    
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
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitTest = super.hitTest(point, with: event) else { return nil }
        
        if hitTest == self || subviews.contains(hitTest) {
            let previous = bounds.maxX / 3
            let next = (bounds.maxX / 3) * 2
            
            if point.x <= previous || point.x >= next {
                return self
            } else {
                return nil
            }
        }
        
        return hitTest
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let previous = bounds.maxX / 3
        let next = (bounds.maxX / 3) * 2
        
        if location.x <= previous {
            previousTapped.accept(())
        } else if location.x >= next {
            nextTapped.accept(())
        }
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

extension Reactive where Base: CalendarHeaderView {
    var previousTapped: Observable<Void> {
        base.previousTapped.asObservable()
    }
    
    var nextTapped: Observable<Void> {
        base.nextTapped.asObservable()
    }
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    CalendarHeaderView()
}
