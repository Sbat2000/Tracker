//
//  TrackerCreateSerivceDelegate.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 27.05.2023.
//

import Foundation

protocol DataProviderDelegate: AnyObject {
    func addTrackers(trackersCategory: TrackerCategory)
    func updateVisibleCategories(_ newCategory: [TrackerCategory])
}
