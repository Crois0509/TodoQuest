//
//  CoreDataManager.swift
//  TodoQuest
//
//  Created by 장상경 on 8/19/25.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa
import ReactorKit

// MARK: - CoreData Protocols

protocol EntityTransformable {
    associatedtype Entity: NSManagedObject
    func toEntity(context: NSManagedObjectContext) -> Entity
}

protocol CoreDataManagable: AnyObject {
    associatedtype Model: EntityTransformable
    associatedtype Entity: NSManagedObject
    
    var persistentContainer: NSPersistentContainer { get }
    
    func create(with model: Model)
    func fetch() -> Single<[Entity]>
    func update(_ id: NSManagedObjectID, updateData: Entity)
    func search(_ id: NSManagedObjectID) -> Entity?
    func delete(_ entity: Entity)
    func save() throws
}

extension CoreDataManagable {
    
    var persistentContainer: NSPersistentContainer {
        let container = NSPersistentContainer(name: "TodoList")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as? NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }
    
}

// MARK: - CoreDataManager

final class CoreDataManager: CoreDataManagable, ReactiveCompatible {
    typealias Model = TodoDTO
    typealias Entity = Todo
    
    private lazy var context = persistentContainer.viewContext
    
    func create(with model: Model) {
        _ = model.toEntity(context: context)
        try? save()
    }
    
    func fetch() -> Single<[Entity]> {
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        let todoList = try? context.fetch(request)
        
        return .just(todoList ?? [])
    }

    func update(_ id: NSManagedObjectID, updateData: Entity) {
        guard var _ = search(id) else { return }
        _ = updateData
        try? save()
    }

    func search(_ id: NSManagedObjectID) -> Entity? {
        do {
            let data = try context.existingObject(with: id) as? Entity
            return data
            
        } catch {
            print(error)
            return nil
        }
    }

    func delete(_ entity: Entity) {
        context.delete(entity)
        try? save()
    }
    
    func save() throws {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
            debugPrint("context saved")
        } catch let error {
            debugPrint("Error saving Core Data: \(error)")
        }
    }
}

extension Reactive where Base: CoreDataManager {
    
    func fetchTodoList() -> Observable<[Todo]> {
        base.fetch().asObservable()
    }
    
}
