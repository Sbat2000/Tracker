//
//  RoundedLabelClass.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 24.05.2023.
//

import UIKit

final class RoundedLabel: UILabel {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}
