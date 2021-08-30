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

enum CoreDataEntity: String {
    case postCoreData = "PostCoreData"
    case postCommentCoreData = "PostCommentCoreData"
}

class CoreDataManager<Element: Equatable> {
    
    private var persistentContainer: NSPersistentContainer!
    private let entityName: String
    
    //var elements: BehaviorRelay<[Element]> = .init(value: [])
    
    init(entity: CoreDataEntity){
        self.entityName = entity.rawValue
        persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    var context: NSManagedObjectContext {
        get {
            return persistentContainer.viewContext
        }
    }
    
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
    
    func saveElements(){
        do {
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
}
