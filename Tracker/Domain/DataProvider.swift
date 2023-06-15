//
//  TrackerCreateService.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 27.05.2023.
//


import UIKit


final class DataProvider {
    
    
    private init() {}
    
    static let shared = DataProvider()
    
    private lazy var trackerStore = TrackerStore.shared
    
    weak var delegate: DataProviderDelegate?
    var emoji = "🙂"
    var color: UIColor = .colorSection1
    var category: String = "Важное"
    private var schedule: [Int] = []
    
    private var visibleCategories: [TrackerCategory]?
    private var completedTrackers: [TrackerRecord]?
    
    let arrayOfEmoji = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    let arrayOfColors: [UIColor] = [.colorSection1,
                                    .colorSection2,
                                    .colorSection3,
                                    .colorSection4,
                                    .colorSection5,
                                    .colorSection6,
                                    .colorSection7,
                                    .colorSection8,
                                    .colorSection9,
                                    .colorSection10,
                                    .colorSection11,
                                    .colorSection12,
                                    .colorSection13,
                                    .colorSection14,
                                    .colorSection15,
                                    .colorSection16,
                                    .colorSection17,
                                    .colorSection18,]
    
    private let shortDayArray = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    
    
    func updateCategories() {
        let category = trackerStore.fetchTrackers()
        delegate?.updateVisibleCategories(category)
    }
    
    func setCategory(category: String) {
        self.category = category
    }
    
    func addDay(day: Int){
        schedule.append(day)
    }
    
    func removeDay(day: Int) {
        schedule.removeAll { $0 == day }
    }
    
    func scheduleContains(_ day: Int) -> Bool {
        schedule.contains(day)
    }
 
    func createTracker(title: String) {
//        let tracker = TrackerCategory(
//            header: category,
//            trackers: [Tracker(
//                id: UUID(), name: title,
//                               color: self.color,
//                               emoji: emoji,
//                               schedule: schedule)])
        let tracker = Tracker(id: UUID(),
                              name: title,
                              color: self.color,
                              emoji: emoji,
                              schedule: schedule)
        //delegate?.addTrackers(trackersCategory: tracker)
        trackerStore.addTracker(model: tracker)
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
        color = .colorSection1
        emoji = "🙂"
    }
    

}
