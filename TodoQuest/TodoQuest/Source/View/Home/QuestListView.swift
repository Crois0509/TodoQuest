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
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        backgroundColor = .clear
        separatorStyle = .singleLine
        separatorInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        rowHeight = 40
        register(QuestCell.self, forCellReuseIdentifier: QuestCell.id)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
