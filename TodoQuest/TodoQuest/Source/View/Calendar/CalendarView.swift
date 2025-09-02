//
//  CalendarView.swift
//  TodoQuest
//
//  Created by 장상경 on 9/2/25.
//

import UIKit
import SnapKit
import Then
import FSCalendar
import RxSwift
import RxCocoa

final class CalendarView: FSCalendar {
    
    // MARK: - Reactive Properties
    
    fileprivate let selectedDateEvent = PublishRelay<Date>()
    
    // MARK: - Properties
    
    /// 이벤트가 새롭게 설정되면, 이전 이벤트와 비교하여 새로운 값만 이벤트 reload
    var events: [Date] = [] {
        didSet {
            guard oldValue != events else { return }
            let filteredEvent = events.filter { !oldValue.contains($0) }
            
            filteredEvent.forEach {
                _ = calendar(self, numberOfEventsFor: $0)
            }
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Function
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rowHeight = bounds.width / 7
        weekdayHeight = rowHeight
    }
    
}

// MARK: - CalendarView Private Method

private extension CalendarView {
    
    func setupUI() {
        backgroundColor = .clear
        firstWeekday = 1
        allowsMultipleSelection = false
        locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        placeholderType = .fillHeadTail
        scrollEnabled = true
        headerHeight = 0
        delegate = self
        dataSource = self
        
        setCurrentPage(Date(), animated: false)
        select(Date())
    }
    
    func setupAppearance() {
        appearance.weekdayFont = .SCDream(size: 16, weight: .medium)
        appearance.weekdayTextColor = .Label.darkLabel
        
        appearance.titleFont = .SCDream(size: 16, weight: .regular)
        appearance.titleDefaultColor = .CustomColors.blueGray
        appearance.titleTodayColor = .CustomColors.personal
        appearance.titlePlaceholderColor = .View.lightGrayBody
        
        appearance.selectionColor = .CustomColors.personal
        appearance.borderRadius = 0.5
        
        appearance.todayColor = .clear
        appearance.todaySelectionColor = .CustomColors.personal
        
        appearance.eventDefaultColor = .CustomColors.personal
        appearance.eventSelectionColor = .CustomColors.personal
    }
    
}

// MARK: - CalendarView Delegate&DataSource

extension CalendarView: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let todayEvent = events.filter { Calendar.current.isDate($0, equalTo: date, toGranularity: .day) }
        
        return min(todayEvent.count, 3)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDateEvent.accept(date)
    }
    
}

// MARK: - CalendarView Reactive Extension

extension Reactive where Base: CalendarView {
    var selectedDate: Observable<Date> {
        base.selectedDateEvent.asObservable()
    }
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    CalendarView()
}
