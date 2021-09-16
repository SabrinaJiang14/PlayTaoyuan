//
//  CoreDataViewModel.swift
//  PlayTaoyuan
//
//  Created by Eileen on 2021/9/14.
//

import Foundation
import CoreData
import UIKit
import Combine

class CoreDataViewModel : NSObject, DatabaseProtocol {
    
    var number:Int = 0
    
    @Published var mStores:[StoreProtocol] = []
    var storesPublisher: Published<[StoreProtocol]>.Publisher { $mStores }
    
    var fetchResultController:NSFetchedResultsController<Store>!
    
    private var context:NSManagedObjectContext!
    private var appDelegate:AppDelegate!
    
    override init() {
        super.init()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.appDelegate = appDelegate
            self.context = appDelegate.persistentContainer.viewContext
        }
    }
    
    func viewDidLoad() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
            if let fetchObjects = fetchResultController.fetchedObjects {
                mStores = fetchObjects.reversed()
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func createStore() {
        let store = Store(context: context)
        store.name = "哈哈餐廳+\(number)"
        store.phone = "009988889998"
        store.address = "台北市內湖區港墘路三段101號"
        number += 1
        try! context.save()
    }
    
    func deleteStore(index:IndexPath) {
        let context = appDelegate.persistentContainer.viewContext
        let objectToDelete = self.fetchResultController.object(at: index)
        context.delete(objectToDelete)
        try! context.save()
    }
}

extension CoreDataViewModel:NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //refresh table view
        print("controllerWillChangeContent")
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //refresh table view
        print("controllerDidChangeContent")
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if let fetchedObjects = controller.fetchedObjects {
            mStores = (fetchedObjects as! [Store]).reversed()
        }
    }
}

protocol StoreProtocol {
    func getName() -> String
    func getPhone() -> String
    func getAddress() -> String
}

extension Store : StoreProtocol {
    func getName() -> String { return self.name ?? "" }
    func getPhone() -> String { return self.phone ?? ""}
    func getAddress() -> String { return self.address ?? ""}
}
