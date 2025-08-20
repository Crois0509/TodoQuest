//
//  TodoDTO.swift
//  TodoQuest
//
//  Created by 장상경 on 8/19/25.
//

import UIKit
import CoreData

struct TodoDTO: EntityTransformable {
    let quest: String
    let date: Date
    let isClear: Bool
    let priority: Int
    let compensation: String?
    
    func toEntity(context: NSManagedObjectContext) -> Todo {
        let todo = Todo(context: context)
        todo.quest = self.quest
        todo.date = self.date
        todo.isClear = self.isClear
        todo.priority = Int16(self.priority)
        todo.compensation = self.compensation
        
        return todo
    }
}
