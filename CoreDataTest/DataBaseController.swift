//
//  DataBaseController.swift
//  CoreDataTest
//
//  Created by Victor Vieira on 19/08/20.
//  Copyright © 2020 Victor Vieira. All rights reserved.
//

import Foundation
import CoreData

class DataBaseController{
    static var persistentController: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataTest")
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError?{
                fatalError("erro ao criar bd, \(error) , \(error.userInfo )")
            }
        })
        return container
    }()
    init() {}
    
    class func getContext() -> NSManagedObjectContext{
        return DataBaseController.persistentController.viewContext
    }
    
    class func saveContext(_ context:NSManagedObjectContext){
        if context.hasChanges{
            do{
                try context.save()
            }
            catch{
                let nserror = error as NSError
                fatalError("erro ao acessar banco de dados \(nserror.userInfo)")
            }
        }
    }
    
}
