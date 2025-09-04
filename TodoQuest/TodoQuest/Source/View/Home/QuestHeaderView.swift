//
//  QuestHeaderView.swift
//  TodoQuest
//
//  Created by 장상경 on 8/11/25.
//

import UIKit
import Then
import SnapKit

final class QuestHeaderView: UILabel {
    
    static let id = "QuestHeaderView"
    
    init(_ headerTitle: String?) {
        super.init(frame: .zero)
        text = headerTitle
        font = .SCDream(size: 20, weight: .bold)
        textColor = .Label.blackLabel
        textAlignment = .left
        backgroundColor = .Background.background
        numberOfLines = 1
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
