//
//  CoreDataManager.swift
//  TodoQuest
//
//  Created by 장상경 on 8/19/25.
//

import UIKit
import CoreData

// MARK: - CoreData Protocols

protocol EntityTransformable {
    associatedtype Entity: NSManagedObject
    func toEntity(context: NSManagedObjectContext) -> Entity
}
