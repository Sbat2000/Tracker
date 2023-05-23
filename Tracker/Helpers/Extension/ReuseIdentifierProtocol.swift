//
//  ReuseIdentifierProtocol.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 23.05.2023.
//

import Foundation

protocol ReuseIdentifier { }

extension ReuseIdentifier {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
