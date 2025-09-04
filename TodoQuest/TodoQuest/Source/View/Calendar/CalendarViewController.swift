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
import FSCalendar

final class CalendarViewController: UIViewController {
    
    // MARK: - Rx Properties
    
    var disposeBag = DisposeBag()
    private let selectedDateEvent = PublishRelay<Date>()
    
    // MARK: - Properties
    
    private var dataSource: DataSource!
    
    /// 이벤트가 새롭게 설정되면, 이전 이벤트와 비교하여 새로운 값만 이벤트 reload
    private var events: [Date] = [] {
        didSet {
            guard oldValue != events else { return }
            let filteredEvent = events.filter { !oldValue.contains($0) }
            
            filteredEvent.forEach {
                _ = calendar(calendarView, numberOfEventsFor: $0)
            }
        }
    }
    
    private var calendarHeightConstraint: Constraint?
    
    // MARK: - UI Components
    
    private let indicator = UIActivityIndicatorView().then {
        $0.style = .large
        $0.color = .white
        $0.backgroundColor = .black.withAlphaComponent(0.3)
    }
    
    private let calendarHeader = CalendarHeaderView()
    private lazy var calendarView = CalendarView().then {
        $0.delegate = self
        $0.dataSource = self
    }
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
        [calendarHeader, questListView, calendarView, indicator].forEach {
            view.addSubview($0)
        }
        
        calendarHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(32)
        }
        
        questListView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalTo(calendarHeader)
            $0.bottom.equalToSuperview()
            $0.height.greaterThanOrEqualTo(view.safeAreaLayoutGuide).multipliedBy(0.4)
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(calendarHeader.snp.bottom).offset(8)
            $0.directionalHorizontalEdges.equalTo(calendarHeader)
            $0.bottom.equalTo(questListView.snp.top)
            self.calendarHeightConstraint = $0.height.equalTo(300).constraint
        }
        
        indicator.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    func changeCalendarScope(_ isWeek: Bool) {
        if isWeek {
            calendarView.setScope(.week, animated: true)
        } else {
            calendarView.setScope(.month, animated: true)
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
        questListView.backgroundView?.isHidden = !items.isEmpty
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

// MARK: - CalendarView Delegate&DataSource

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let todayEvent = events.filter { Calendar.current.isDate($0, equalTo: date, toGranularity: .day) }
        
        return min(todayEvent.count, 3)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDateEvent.accept(date)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint?.update(offset: bounds.height)
    }
    
}

// MARK: - CalendarVC Reactor

extension CalendarViewController: View {
    
    func bind(reactor: CalendarReactor) {
        
        // MARK: - Output
        
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
            }
            .disposed(by: disposeBag)
        
        reactor.state.compactMap(\.headerTitle)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, title in
                owner.calendarHeader.configTitle(title)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map(\.currentPage)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, date in
                owner.calendarView.setCurrentPage(date, animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map(\.allItems)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, items in
                owner.events = items.compactMap { $0.editDate }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map(\.calendarScopeIsWeek)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, isWeek in
                owner.changeCalendarScope(isWeek)
            }
            .disposed(by: disposeBag)
        
        // MARK: - Input
        
        Observable.just(.fetchTodoList)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectedDateEvent
            .distinctUntilChanged()
            .map { .selectedDate($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable.merge(
            calendarHeader.rx.nextTapped.map { [weak self] _ in
                if let self, self.calendarView.scope == .month {
                    return self.calendarView.currentPage.addMonth(1)
                } else if let self, self.calendarView.scope == .week {
                    return self.calendarView.currentPage.addWeek(1)
                } else {
                    return Date()
                }
            },
            calendarHeader.rx.previousTapped.map { [weak self] _ in
                if let self, self.calendarView.scope == .month {
                    return self.calendarView.currentPage.addMonth(-1)
                } else if let self, self.calendarView.scope == .week {
                    return self.calendarView.currentPage.addWeek(-1)
                } else {
                    return Date()
                }
            }
        )
        .distinctUntilChanged()
        .map { .changeCurrentPage($0) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        questListView.rx.contentOffset
            .distinctUntilChanged()
            .map { .changeScrollOffset($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
}

// MARK: - CalendarVC Preview

@available(iOS 17.0, *)
#Preview {
    CalendarViewController()
}
