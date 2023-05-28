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
    private let shortDayArray = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    
    private init() {}
    
    var category: String = "Важное"
    private var schedule: [Int] = []
    
    func setCategory(category: String) {
        self.category = category
        print(self.category)
    }
    
    func addDay(day: Int){
        schedule.append(day)
        print(schedule)
    }
    
    func removeDay(day: Int) {
        schedule.removeAll { $0 == day }
        print(schedule)
    }
    
    func scheduleContains(_ day: Int) -> Bool {
        schedule.contains(day)
    }
 
    func createTracker(title: String) {
        let tracker = TrackerCategory(
            header: category,
            trackers: [Tracker(
                               name: title,
                               color: .colorSection1,
                               emoji: "🐕",
                               schedule: schedule)])
        print("CREATE TRACKER: \(tracker)")
        delegate?.addTrackers(trackersCategory: tracker)
        clean()
    }
    
    func getFormattedSchedule() -> String? {
        guard !schedule.isEmpty else {
            return nil
        }
        
        let days = schedule.map { shortDayArray[$0 - 1] }
        return days.joined(separator: ", ")
    }
    
    private func clean() {
        schedule = []
    }
    
    
}
