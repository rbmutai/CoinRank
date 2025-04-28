//
//  PersistenceController.swift
//  CoinRank
//
//  Created by Robert Mutai on 28/04/2025.
//

import Foundation
import CoreData
class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    let viewContext: NSManagedObjectContext

    init(inMemory: Bool = false){
        container = NSPersistentContainer(name: "CoinRank")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
        })
        
        viewContext = container.newBackgroundContext()
    }
    
    func saveFavouriteCoin(uuid: String){
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteCoins")
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)
        
        do {
            let favouriteObject = try viewContext.fetch(fetchRequest)
            //check if exists and exit function if so
            if favouriteObject.count > 0 {
                return
            }
            //else, save favourite coin
            if let entity = NSEntityDescription.entity(forEntityName: "FavouriteCoins", in: viewContext){
                let object = NSManagedObject(entity: entity, insertInto: viewContext)
                object.setValue(uuid, forKey: "uuid")
            }
            
            if viewContext.hasChanges {
                try viewContext.save()
            }
            
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
    func getFaouriteCoins() -> [String] {
        var favourites: [String] = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteCoins")
        
        do {
            let object = try viewContext.fetch(fetchRequest)
             
            for item in object {
                let uuid = item.value(forKey: "uuid") as? String ?? ""
                
                favourites.append(uuid)
            }
            
            return favourites
            
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
        
        return favourites
    }
    
    func deleteFavouriteCoin(uuid: String){
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteCoins")
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)
        
        do {
            let object = try viewContext.fetch(fetchRequest)
            
            for item in object {
                viewContext.delete(item)
            }
            
            try viewContext.save()
            
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
    }
    
}
