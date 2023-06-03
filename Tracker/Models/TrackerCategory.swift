//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 25.05.2023.
//

import Foundation

struct TrackerCategory {
    let header      :String
    let trackers    :[Tracker]
    
    init(header: String, trackers: [Tracker]) {
        self.header = header
        self.trackers = trackers
    }
}
