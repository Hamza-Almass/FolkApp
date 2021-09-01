//
//  CoreDataManager.swift
//  FolkApp
//
//  Created by Hamza Almass on 8/30/21.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa

/// Core data entity
enum CoreDataEntity: String {
    case postCoreData = "PostCoreData"
    case postCommentCoreData = "PostCommentCoreData"
}

/// Core data manager generics
class CoreDataManager<Element: Equatable> {
    //MARK:- Property
    private var persistentContainer: NSPersistentContainer!
    private let entityName: String
    
    //MARK:- init
    /// init to create core data amanager
    /// - Parameter entity: String
    init(entity: CoreDataEntity){
        self.entityName = entity.rawValue
        persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    /// Core data context
    var context: NSManagedObjectContext {
        get {
            return persistentContainer.viewContext
        }
    }
    
    /// Fetch elements from core data
    /// - Returns: [Element]]
    func fetchElements() -> BehaviorRelay<[Element]> {
       
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: self.entityName, in: context)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            return .init(value: try context.fetch(fetchRequest) as! [Element])
        }catch{
            print(error.localizedDescription , "With fetch data from core data")
        }
        return .init(value: [])
    }
    //MARK:- Delete all objects from core data
    /// Delete all objects from core data
    func deleteAllObjectsInCoreData(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: self.entityName, in: context)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
        }catch{
            print(error.localizedDescription , "With deleting elements in core data")
        }
    }
    
    func deleteAllCommentsObjectsInCoreDataDepenedOn(PostId id: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: self.entityName, in: context)
        fetchRequest.predicate = NSPredicate(format: "postId CONTAINS[cd] %@", argumentArray: [id])
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        print("Here")
        do {
            try context.execute(batchDeleteRequest)
        }catch{
            print(error.localizedDescription , "With deleting elements in core data")
        }
    }
    
    //MARK:- Fetch element
    /// Fetch elemenet
    /// - Parameters:
    ///   - fieldName: String
    ///   - fieldValue: String
    /// - Returns: element as optional
    func fetchElement(fieldName: String , fieldValue: String) -> Element? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: self.entityName, in: context)
        fetchRequest.predicate = NSPredicate(format: "\(fieldName) == %@", fieldValue)
        do {
            let elemensts = try context.fetch(fetchRequest) as! [Element]
            return elemensts.count > 0 ? elemensts.first : nil
        }catch{
            print(error.localizedDescription)
            return nil
        }
    }
    //MARK:- Save object
    /// Save object to core data
    func saveElements(){
        do {
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
}
