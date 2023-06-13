//
//  TrackerCreateService.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 27.05.2023.
//

import Foundation
import UIKit

final class TrackerCreateService {
    
    static let shared = TrackerCreateService()
    weak var delegate: TrackerCreateServiceDelegate?
    var emoji = "🙂"
    
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
    
    private init() {}
    
    var category: String = "Важное"
    private var schedule: [Int] = []
    
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
        let tracker = TrackerCategory(
            header: category,
            trackers: [Tracker(
                               name: title,
                               color: .colorSection1,
                               emoji: emoji,
                               schedule: schedule)])
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
