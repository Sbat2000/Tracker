//
//  Tracker.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 25.05.2023.
//

import UIKit

struct Tracker {
    let id          :UUID = UUID()
    let name        :String
    let color       :UIColor
    let emoji       :String
    let schedule    :[Int]
}

