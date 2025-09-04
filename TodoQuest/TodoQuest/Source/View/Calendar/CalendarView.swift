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
    
    override func setCurrentPage(_ currentPage: Date, animated: Bool) {
        scrollEnabled = true
        super.setCurrentPage(currentPage, animated: animated)
        scrollEnabled = false
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
        scrollEnabled = false
        headerHeight = 0        
        setCurrentPage(Date(), animated: false)
        select(Date())
    }
    
    func setupAppearance() {
        appearance.weekdayFont = .SCDream(size: 16, weight: .medium)
        appearance.weekdayTextColor = .Label.darkLabel
        
        appearance.titleFont = .SCDream(size: 14, weight: .regular)
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

// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    CalendarView()
}
