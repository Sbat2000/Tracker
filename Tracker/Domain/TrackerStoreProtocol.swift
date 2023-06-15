//
//  TrackerStoreProtocol.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 15.06.2023.
//

import Foundation

protocol TrackerStoreProtocol: AnyObject {
    func addTracker(model: Tracker)
    func fetchTrackers() -> [TrackerCategory]
}
