//
//  CoreDataAPI.swift
//  BoysAndGirls
//
//  Created by Vitaliy on 19.11.2019.
//  Copyright © 2019 Vitaliy. All rights reserved.
//

import CoreData
import UIKit

class DataStorage {
    
    private struct Constants {
        static let entityName: String = "Image"
        static let binaryKey: String = "binaryData"
        static let isSelectedKey: String = "isSelected"
    }
    
    // read all objects from db
    func readAllObjects(fromEntityName entityName: String) -> [Image] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)
        let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)
        var images: [Image] = []
        
        do {
            let results = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for data in results {
                guard let imageBinaryData = data.value(forKey: Constants.binaryKey) as? Data else { return [] }
                guard let imageIsSelectedValue = data.value(forKey: Constants.isSelectedKey) as? Bool else { return [] }
                
                let image = Image(entity: entityDescription!, insertInto: managedContext)
                image.binaryData = imageBinaryData
                image.isSelected = imageIsSelectedValue
                images.append(image)
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return images
    }
    
    // delete object by index from db
    func deleteObjectByIndex(_ index: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
        
        do {
            let items = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            let objectToDelete = items[index]
            managedContext.delete(objectToDelete)
            
            do {
                try managedContext.save()
                
            } catch let error as NSError {
                print("Object not delete: \(error.localizedDescription)")
            }
            
        } catch let error as NSError {
            print("Context not fetched: \(error.localizedDescription)")
        }
    }
    
    // write object to db
    func writeObject(unsplashPhoto: UnsplashPhoto) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let imageEntity = NSEntityDescription.entity(forEntityName: Constants.entityName, in: managedContext)!
        let imageObject = NSManagedObject(entity: imageEntity, insertInto: managedContext)
        
        if let url = unsplashPhoto.urls["small"], let data = try? Data(contentsOf: URL(string: url)!) {
            imageObject.setValue(data, forKey: Constants.binaryKey)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func writeObjectS(objects: [UnsplashPhoto]) {
        let persistentContainer = NSPersistentContainer(name: "BoysAndGirls")
        
        persistentContainer.performBackgroundTask { context in
            objects.forEach { unsplashPhoto in
                let photo = Image(context: context)
                //photo.binaryData = unsplashPhoto.
            }
        }
    }
    
    // delete all objects from db
    func deleteAllData(_ entity: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.includesSubentities = false
        
        do {
            let items = try managedContext.fetch(fetchRequest) as! [NSManagedObject]

            for item in items {
                managedContext.delete(item)
            }
            
            // save changes
            try managedContext.save()
            
        } catch let error as NSError{
            print("Delete all data in \(entity) entity is error: \(error)")
        }
        
    }
}
