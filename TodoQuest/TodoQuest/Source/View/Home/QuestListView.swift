//
//  QuestListView.swift
//  TodoQuest
//
//  Created by 장상경 on 8/10/25.
//

import UIKit
import Then
import SnapKit

final class QuestListView: UITableView {
    
    private let emptyLabel = UILabel().then {
        $0.text = "퀘스트가 없습니다."
        $0.font = .SCDream(size: 16, weight: .medium)
        $0.textColor = .Label.grayLabel
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.backgroundColor = .clear
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        backgroundColor = .clear
        separatorStyle = .none
        separatorInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundView = emptyLabel
        backgroundView?.isHidden = true
        rowHeight = 40
        register(QuestCell.self, forCellReuseIdentifier: QuestCell.id)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
