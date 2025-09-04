//
//  CalendarReactor.swift
//  TodoQuest
//
//  Created by 장상경 on 9/2/25.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class CalendarReactor: Reactor {
    let initialState: State = State()
    private let manager: CoreDataManager
    
    init(repo: CoreDataManager) {
        self.manager = repo
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchTodoList:
            return .concat(
                .just(.setLoading(true)),
                manager.rx.fetchTodoList().map { .setAllItems($0) },
                .just(.setLoading(false))
            )
            
        case .selectedDate(let date):
            return .just(.selectedTodoList(date))

        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
            
        case .setAllItems(let todo):
            let items = todo.map {
                QuestItem(editDate: $0.date,
                          quest: $0.quest,
                          check: $0.isClear,
                          priority: QuestPriority.allCases[Int($0.priority)]
                )
            }
            newState.allItems = items
            
            debugPrint("load items count: \(items.count)")
            
            let defaultDate = Date()
            newState.selectTodoList = items.filter { Calendar.current.isDate($0.editDate ?? Date(), equalTo: defaultDate, toGranularity: .day) }
            
        case .selectedTodoList(let date):
            let selectItems = state.allItems.filter {
                Calendar.current.isDate($0.editDate ?? Date(), equalTo: date, toGranularity: .day)
            }.sorted { first, _ in first.check }
            
            newState.selectTodoList = selectItems
            debugPrint("filtered load items count: \(selectItems.count)")
            
        }
        
        return newState
    }
}

extension CalendarReactor {
    
    enum Action {
        case fetchTodoList
        case selectedDate(Date)
        case changeCurrentPage(Date)
        case changeScrollOffset(CGPoint)
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setAllItems([Todo])
        case selectedTodoList(Date)
        case setCurrentPage(Date)
        case setCalendarScale(CGPoint)
    }
    
    struct State {
        var allItems: [QuestItem] = []
        var selectTodoList: [QuestItem] = []
        var currentPage: Date = Date()
        var headerTitle: String? = Date().dateFormatToYearMonth()
        var isLoading: Bool = false
        var calendarScopeIsWeek: Bool = false
    }
    
}
