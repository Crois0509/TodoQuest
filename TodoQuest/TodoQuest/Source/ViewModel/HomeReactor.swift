//
//  HomeReactor.swift
//  TodoQuest
//
//  Created by 장상경 on 9/4/25.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class HomeReactor: Reactor {
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
                manager.rx.fetchTodoList().map { .setTodoItems($0) },
                .just(.setLoading(false))
            )
            
        case .requestShowModal:
            return .just(.showQuestModal(nil))
            
        case .requestShowTodoEditer(let indexPath):
            return .just(.showQuestModal(indexPath))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
            
        case .setTodoItems(let todos):
            let items = todos.map {
                QuestItem(editDate: $0.date,
                          quest: $0.quest,
                          check: $0.isClear,
                          priority: QuestPriority.allCases[Int($0.priority)]
                )
            }.filter {
                Calendar.current.isDate($0.editDate ?? Date(), equalTo: Date(), toGranularity: .day)
            }
            
            newState.todoItems = items
            
        case .showQuestModal(let indexPath):
            if let indexPath {
                newState.modalItem = newState.todoItems[indexPath.row]
            } else {
                newState.modalItem = nil
            }
        }
        
        return newState
    }
}

extension HomeReactor {
    enum Action {
        case fetchTodoList
        case requestShowModal
        case requestShowTodoEditer(IndexPath)
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setTodoItems([Todo])
        case showQuestModal(IndexPath?)
    }
    
    struct State {
        var todoItems: [QuestItem] = []
        var isLoading: Bool = false
        var modalItem: QuestItem? = nil
    }
}
