//
//  ScheduleCellDelegate.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 27.05.2023.
//

import Foundation

protocol ScheduleCellDelegate: AnyObject {
    func scheduleCell(_ cell: ScheduleCell, didChangeSwitchValue isOn: Bool)
}
