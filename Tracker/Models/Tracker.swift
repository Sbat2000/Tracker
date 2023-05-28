//
//  Tracker.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 25.05.2023.
//

import UIKit

struct Tracker {
    let id          :UInt
    let name        :String
    let color       :UIColor
    let emoji       :String
    let schedule    :[String]?
}

enum WeekDay: String, CaseIterable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
}
