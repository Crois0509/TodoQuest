//
//  HomeViewController.swift
//  TodoQuest
//
//  Created by 장상경 on 8/8/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import ReactorKit

final class HomeViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    private var dataSource: DataSource!
    
    private let indicator = IndicatorView()
    private let profileView = MainProfileView()
    private let questList = QuestListView()
    private let addButton = UIButton(configuration: .floatingButtonStyle).then {
        $0.layer.shadowColor = UIColor.Label.blackLabel.cgColor
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = .init(width: 0, height: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        profileView.configProfile(.init(image: nil, name: "Admin1234", level: 10, exp: 980, progress: 0.54))
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        profileView.layer.shadowColor = UIColor.Label.blackLabel.cgColor
        addButton.layer.shadowColor = UIColor.Label.blackLabel.cgColor
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let inset = view.safeAreaInsets.bottom > 0 ? 116 : 88
        addButton.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(inset)
        }
        
        DispatchQueue.main.async {
            self.profileView.layer.shadowPath = self.profileView.shadowPath
            self.addButton.layer.shadowPath = UIBezierPath(roundedRect: self.addButton.bounds, cornerRadius: self.addButton.bounds.height / 2).cgPath
        }
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
        [profileView, questList, addButton, indicator].forEach {
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
        
        addButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(116)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(80)
        }
        
        indicator.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
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
        snapshot.appendSections([.todayQuest])
        snapshot.appendItems([], toSection: .todayQuest)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func updateSnapShot(_ items: [QuestItem]) {
        var snapshot = dataSource.snapshot()
        let filteredItems = items.filter { !snapshot.itemIdentifiers.contains($0) }
        
        questList.backgroundView?.isHidden = !filteredItems.isEmpty
        
        snapshot.appendItems(filteredItems, toSection: .todayQuest)
        dataSource.apply(snapshot, animatingDifferences: true)
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

// MARK: - HomeVC Reactor

extension HomeViewController: View {
    
    func bind(reactor: HomeReactor) {
        
        // MARK: - Output
        
        reactor.state.map(\.todoItems)
            .skip(until: self.rx.viewDidAppear)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, items in
                owner.updateSnapShot(items)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map(\.isLoading)
            .distinctUntilChanged()
            .bind(to: indicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.modalItem)
            .skip(until: Observable.merge(addButton.rx.tap.map { _ in }, questList.rx.itemSelected.map { _ in }))
            .withUnretained(self)
            .bind { owner, item in
                // Modal Present
                debugPrint("show modal \(item)")
            }
            .disposed(by: disposeBag)
        
        // MARK: - Input
        
        self.rx.viewDidAppear
            .take(1)
            .map { .fetchTodoList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler())
            .map { .requestShowModal }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        questList.rx.itemSelected
            .skip(until: self.rx.viewDidAppear)
            .throttle(.seconds(1), scheduler: MainScheduler())
            .map { .requestShowTodoEditer($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
}

@available(iOS 17.0, *)
#Preview {
    HomeViewController()
}
