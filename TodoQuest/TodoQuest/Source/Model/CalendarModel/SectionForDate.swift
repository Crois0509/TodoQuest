//
//  SectionForDate.swift
//  TodoQuest
//
//  Created by 장상경 on 9/2/25.
//

import Foundation

enum SectionForDate: CaseIterable {
    case dateSection
    
    var sectionTitle: String {
        switch self {
        case .dateSection:
            return "퀘스트 목록"
        }
    }
}
