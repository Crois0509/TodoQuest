//
//  QuestCell.swift
//  TodoQuest
//
//  Created by 장상경 on 8/10/25.
//

import UIKit
import Then
import SnapKit

final class QuestCell: UITableViewCell {
    
    static let id = "QuestCell"
    
    private let checkBox = UIButton().then {
        $0.setImage(UIImage(systemName: "square"), for: .normal)
        $0.tintColor = .CustomColors.blueGray
        $0.backgroundColor = .clear
    }
    
    private let questLabel = UILabel().then {
        $0.font = .SCDream(size: 16, weight: .regular)
        $0.numberOfLines = 1
        $0.textColor = .Label.darkLabel
        $0.textAlignment = .left
        $0.backgroundColor = .clear
    }
    
    private let priorityLabel = UILabel().then {
        $0.font = .SCDream(size: 12, weight: .light)
        $0.numberOfLines = 1
        $0.textColor = .CustomColors.mainWhite
        $0.textAlignment = .center
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.addBottomBorderWithShapeLayer(with: .View.lightGrayBody, and: 2)
    }
    
    func configCell(_ quest: String, _ complete: Bool, _ priority: QuestPriority) {
        questLabel.text = quest
        priorityLabel.text = priority.rawValue
        priorityLabel.backgroundColor = priority.priorityColor
        
        if complete {
            checkBox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            checkBox.tintColor = .CustomColors.personal
        }
    }
    
}

// MARK: - UI Setting Method

private extension QuestCell {
    
    func setupUI() {
        configureSelf()
        setupLayout()
    }
    
    func configureSelf() {
        [checkBox, questLabel, priorityLabel].forEach {
            contentView.addSubview($0)
        }
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear
    }
    
    func setupLayout() {
        checkBox.snp.makeConstraints {
            $0.leading.directionalVerticalEdges.equalToSuperview()
            $0.width.lessThanOrEqualTo(40)
        }
        
        questLabel.snp.makeConstraints {
            $0.leading.equalTo(checkBox.snp.trailing)
            $0.directionalVerticalEdges.equalToSuperview()
        }
        
        priorityLabel.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview().inset(5)
            $0.trailing.equalToSuperview().inset(10)
            $0.leading.equalTo(questLabel.snp.trailing)
            $0.width.lessThanOrEqualTo(40)
        }
    }
    
}
