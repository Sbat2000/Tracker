//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 16.06.2023.
//

import UIKit
import CoreData

final class TrackerRecordStore: NSObject {
    
    private lazy var appDelegate = {
        UIApplication.shared.delegate as! AppDelegate
    }()
    private lazy var context = {
        appDelegate.persistentContainer.viewContext
    }()

    private lazy var fetchedResultController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerRecordCoreData.id, ascending: true)]
        let fetchController = NSFetchedResultsController(fetchRequest: request,
                                                         managedObjectContext: context,
                                                         sectionNameKeyPath: nil,
                                                         cacheName: nil)
        fetchController.delegate = self
        
        do {
            try fetchController.performFetch()
        } catch  {
            print(error.localizedDescription)
        }
        return fetchController
    }()
    
    func getRecords() {
        
    }
    
    func addTrackerRecord(_ record: TrackerRecord) {
        let newRecord = TrackerRecordCoreData(context: context)
        newRecord.id = record.id
        newRecord.date = record.date
        appDelegate.saveContext()
    }
    
    func deleteTrackerRecord(_ record: TrackerRecord) {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND date == %@", record.id.uuidString, record.date)

        do {
            let matchingRecords = try context.fetch(fetchRequest)
            if let recordToDelete = matchingRecords.first {
                context.delete(recordToDelete)
                appDelegate.saveContext()
            }
        } catch {
            print("Error deleting tracker record: \(error.localizedDescription)")
        }
    }
    
    func getRecords() -> Set<TrackerRecord> {
        var recordsSet = Set<TrackerRecord>()
        
        guard let fetchedRecords = fetchedResultController.fetchedObjects else {
            return recordsSet
        }
        
        for fetchedRecord in fetchedRecords {
            guard let id = fetchedRecord.id,
                  let dateString = fetchedRecord.date else {
                continue
            }
            
            let trackerRecord = TrackerRecord(id: id, date: dateString)
            recordsSet.insert(trackerRecord)
        }
        
        return recordsSet
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        try? fetchedResultController.performFetch()
        
    }
}


