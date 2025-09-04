//
//  Date+Ext.swift
//  TodoQuest
//
//  Created by 장상경 on 9/3/25.
//

import UIKit

extension Date {
    
    func dateFormatToMonthDay() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    func dateFormatToYearMonth() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    func addMonth(_ value: Int) -> Date {
        let date = Calendar.current.date(byAdding: .month, value: value, to: self)
        return date ?? Date()
    }
    
    func addWeek(_ value: Int) -> Date {
        let date = Calendar.current.date(byAdding: .weekOfMonth, value: value, to: self)
        return date ?? Date()
    }
    
}
