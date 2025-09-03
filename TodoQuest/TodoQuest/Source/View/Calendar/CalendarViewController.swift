//
//  CalendarViewController.swift
//  TodoQuest
//
//  Created by 장상경 on 9/1/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import ReactorKit

final class CalendarViewController: UIViewController {
    
    // MARK: - Rx Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    private var dataSource: DataSource!
    
    // MARK: - UI Components
    
    private let indicator = UIActivityIndicatorView().then {
        $0.style = .large
        $0.color = .white
        $0.backgroundColor = .black.withAlphaComponent(0.3)
    }
    
    private let calendarHeader = CalendarHeaderView()
    private let calendarView = CalendarView()
    private let questListView = QuestListView().then {
        $0.contentInset.bottom = 100
    }
    
    // MARK: - Override Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
}

// MARK: - UI Setting Method

private extension CalendarViewController {
    
    func setupUI() {
        configureSelf()
        setupLayout()
        setupDataSource()
        applySnapShot([])
    }
    
    func configureSelf() {
        view.backgroundColor = .Background.background
        questListView.delegate = self
    }
    
    func setupLayout() {
        [calendarHeader, calendarView, questListView, indicator].forEach {
            view.addSubview($0)
        }
        
        calendarHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(32)
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(calendarHeader.snp.bottom)
            $0.directionalHorizontalEdges.equalTo(calendarHeader)
            $0.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.4)
        }
        
        questListView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(24)
            $0.directionalHorizontalEdges.equalTo(calendarView)
            $0.bottom.equalToSuperview()
        }
        
        indicator.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
}

// MARK: - CalenarVC TableView DataSource&SnapShot

private extension CalendarViewController {
    typealias DataSource = UITableViewDiffableDataSource<SectionForDate, QuestItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionForDate, QuestItem>
    
    func setupDataSource() {
        dataSource = .init(tableView: questListView, cellProvider: { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestCell.id, for: indexPath) as? QuestCell else { return UITableViewCell(style: .default, reuseIdentifier: nil)}
            
            cell.configCell(item.quest, item.check, item.priority)
            
            return cell
        })
        
    }
    
    func applySnapShot(_ items: [QuestItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections(SectionForDate.allCases)
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

// MARK: - TableView Delegate - Header Setting
extension CalendarViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = dataSource.sectionIdentifier(for: section) else { return nil }
        
        let headerView = QuestHeaderView(section.sectionTitle)
        
        return headerView
    }
    
}

// MARK: - CalendarVC Reactor

extension CalendarViewController: View {
    
    func bind(reactor: CalendarReactor) {
        reactor.state.map(\.isLoading)
            .distinctUntilChanged()
            .bind(to: indicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.selectTodoList)
            .skip(until: self.rx.viewDidAppear)
            .take(until: self.rx.deallocated)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, items in
                owner.applySnapShot(items)
                debugPrint("updateSnapshot")
            }
            .disposed(by: disposeBag)
        
        Observable.just(.fetchTodoList)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calendarView.rx.selectedDate
            .distinctUntilChanged()
            .map { .selectedDate($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
}

// MARK: - CalendarVC Preview

@available(iOS 17.0, *)
#Preview {
    CalendarViewController()
}
