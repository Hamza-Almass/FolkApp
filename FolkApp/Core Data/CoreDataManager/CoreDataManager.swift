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
    case post
    case postDetails
}

class CoreDataManager<Element: Equatable> {
    
    private var persistentContainer: NSPersistentContainer!
    private let entityName: String
    
    var elements: BehaviorRelay<[Element]> = .init(value: [])
    
    init(entity: CoreDataEntity){
        self.entityName = entity.rawValue
        persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    private var context: NSManagedObjectContext {
        get {
            return persistentContainer.viewContext
        }
    }
    
    func fetchElements(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: self.entityName, in: context)
        do {
            let elements = try context.fetch(fetchRequest) as! [Element]
            self.elements.accept(elements)
        }catch{
            
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
