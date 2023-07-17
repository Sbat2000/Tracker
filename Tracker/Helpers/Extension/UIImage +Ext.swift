//
//  UIImage +Ext.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 28.05.2023.
//

import UIKit

extension UIImage {
    static let placeHolder = UIImage(named: "placeHolder")
    static let notFound = UIImage(named: "notFound")
    static let statsPlaceHolder = UIImage(named: "placeholder stats")
    
    static func gradientImage(bounds: CGRect, colors: [UIColor]) -> UIImage {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = bounds
            gradientLayer.colors = colors.map(\.cgColor)

            // This makes it left to right, default is top to bottom
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

            let renderer = UIGraphicsImageRenderer(bounds: bounds)

            return renderer.image { ctx in
                gradientLayer.render(in: ctx.cgContext)
            }
        }
}
