//
//  QuestSectionModel.swift
//  TodoQuest
//
//  Created by 장상경 on 8/11/25.
//

import Foundation

enum QuestSection: CaseIterable {
    case todayQuest
    case completeQuest
    
    var sectionTitle: String {
        switch self {
        case .todayQuest:
            return "오늘의 퀘스트"
        case .completeQuest:
            return "완료한 퀘스트"
        }
    }
}

struct QuestItem: Hashable {
    let id = UUID()
    let editDate: Date?
    let quest: String?
    let check: Bool
    let priority: QuestPriority
}
