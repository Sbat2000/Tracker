//
//  TrackerStore.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 14.06.2023.
//

import UIKit
import CoreData

final class TrackerStore: NSObject, TrackerStoreProtocol {

    private let colorMarshaling = UIColorMarshalling()
    private let dataProvider = DataProvider.shared
    
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var section: Int?
    
    private lazy var appDelegate = {
        UIApplication.shared.delegate as! AppDelegate
    }()
    
    private lazy var context = {
        appDelegate.persistentContainer.viewContext
    }()
    
    private lazy var fetchedResultController: NSFetchedResultsController<TrackerCoreData> = {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.category?.header, ascending: true)]
        let fetchController = NSFetchedResultsController(fetchRequest: request,
                                                         managedObjectContext: context,
                                                         sectionNameKeyPath: "category.header",
                                                         cacheName: nil)
        fetchController.delegate = self
        
        do {
            try fetchController.performFetch()
        } catch  {
            print(error.localizedDescription)
        }
        return fetchController
    }()
    
    func fetchTrackers() -> [TrackerCategory] {
        guard let section = fetchedResultController.sections else { return [] }
        
        var trackerCategoryArray: [TrackerCategory] = []
        
        for section in section {
            guard let object = section.objects as? [TrackerCoreData] else {
                return []
            }
            
            var trackers: [Tracker] = []
            
            for tracker in object {
                let color = colorMarshaling.color(from: tracker.color ?? "")
                let newTracker = Tracker(id: tracker.id ?? UUID(),
                                         name: tracker.name ?? "",
                                         color: color,
                                         emoji: tracker.emoji ?? "",
                                         schedule: tracker.schedule as? [Int] ?? [])
                trackers.append(newTracker)
               
            }
            let trackerCategory = TrackerCategory(header: section.name, trackers: trackers)
            trackerCategoryArray.append(trackerCategory)
        }
        return trackerCategoryArray
    }
    
    func addTracker(model: Tracker) {
        let category = dataProvider.category
        let tracker = TrackerCoreData(context: context)
        let color = colorMarshaling.hexString(from: model.color)
        
        let categoryFetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
            categoryFetchRequest.predicate = NSPredicate(format: "header == %@", category)
            let categoryResults = try? context.fetch(categoryFetchRequest)
            let categoryCoreData = categoryResults?.first ?? TrackerCategoryCoreData(context: context)
            categoryCoreData.header = category
        
        tracker.id = model.id
        tracker.color = color
        tracker.emoji = model.emoji
        tracker.name = model.name
        tracker.schedule = model.schedule
        tracker.category = categoryCoreData
        
        appDelegate.saveContext()
    }
    
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        guard let insertedIndexes = insertedIndexes,
//              let deletedIndexes = deletedIndexes,
//              let section = section else { return }
        try? fetchedResultController.performFetch()
        dataProvider.updateCategories()
    }
}
