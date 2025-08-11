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
    
    // TODO: Test, MockData
    let todayQuest: [QuestItem] = [
        .init(quest: "영어 단어 암기", check: false, priority: .P0),
        .init(quest: "운동하기", check: false, priority: .P1),
        .init(quest: "독서하기", check: false, priority: .P2),
        .init(quest: "은행 다녀오기", check: false, priority: .P3)
    ]
    
    let completeQuest: [QuestItem] = [
        .init(quest: "아침밥 먹기", check: true, priority: .P0),
        .init(quest: "노트 구매", check: true, priority: .P1),
        .init(quest: "택배 보내기", check: true, priority: .P2),
        .init(quest: "교통카드 충전", check: true, priority: .P3),
    ]
    
    private var dataSource: DataSource!
    
    private let profileView = MainProfileView()
    private let questList = QuestListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        profileView.configProfile(.init(image: nil, name: "Admin1234", level: 10, exp: 980, progress: 0.54))
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        profileView.layer.shadowColor = UIColor.Label.blackLabel.cgColor
    }
    
}

// MARK: - UI Setting Method

private extension HomeViewController {
    
    func setupUI() {
        configureSelf()
        setupLayout()
        setupDataSource()
        applyInitialSnapShot()
    }
    
    func configureSelf() {
        [profileView, questList].forEach {
            view.addSubview($0)
        }
        questList.delegate = self
    }
    
    func setupLayout() {
        profileView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(140)
        }
        
        questList.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(20)
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - QuestList DataSource

private extension HomeViewController {
    typealias DataSource = UITableViewDiffableDataSource<QuestSection, QuestItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<QuestSection, QuestItem>
    
    func setupDataSource() {
        dataSource = .init(tableView: questList, cellProvider: { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestCell.id, for: indexPath) as? QuestCell else { return UITableViewCell(style: .default, reuseIdentifier: nil)}
            
            cell.configCell(item.quest, item.check, item.priority)
            
            return cell
        })
        
    }
    
    func applyInitialSnapShot() {
        var snapshot = Snapshot()
        snapshot.appendSections(QuestSection.allCases)
        snapshot.appendItems(todayQuest, toSection: .todayQuest)
        snapshot.appendItems(completeQuest, toSection: .completeQuest)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}

// MARK: - TableView Delegate

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = dataSource.sectionIdentifier(for: section) else { return nil }
        
        let headerView = QuestHeaderView(section.sectionTitle)
        
        return headerView
    }
    
}

@available(iOS 17.0, *)
#Preview {
    HomeViewController()
}
