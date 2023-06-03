//
//  CategorySelectionDelegate.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 28.05.2023.
//

import Foundation

protocol CategoryViewControllerDelegate: AnyObject {
    func didSelectCategory(_ category: String?)
}
