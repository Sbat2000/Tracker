//
//  TrackerCreateService.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 27.05.2023.
//

import Foundation

final class TrackerCreateService {
    
    static let shared = TrackerCreateService()
    weak var delegate: TrackerCreateServiceDelegate?
    
    private init() {}
    
    private var category: String?
    private var schedule: [String] = []
    
    func setCategory(category: String) {
        self.category = category
        print(self.category)
    }
    
    func addDay(day: String){
        schedule.append(day)
        print(schedule)
    }
    
    func removeDay(day: String) {
        schedule.removeAll { $0 == day }
        print(schedule)
    }
    
    func scheduleContains(_ day: String) -> Bool {
        schedule.contains(day)
    }
 
    func createTracker(title: String) {
        let tracker = TrackerCategory(
            header: category ?? "Важное",
            trackers: [Tracker(id: 0,
                               name: title,
                               color: .colorSection1,
                               emoji: "🐕",
                               schedule: schedule)])
        print("CREATE TRACKER: \(tracker)")
        delegate?.addTrackers(trackersCategory: tracker)
        clean()
    }
    
    private func clean() {
        category = nil
        schedule = []
    }
    
    
}
