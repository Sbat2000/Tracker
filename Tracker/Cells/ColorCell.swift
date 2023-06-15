//
//  EmojiCell.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 12.06.2023.
//


import UIKit

final class ColorCell: UICollectionViewCell {
    
    private var selectedBorderLayer: CALayer?
    
    lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                if selectedBorderLayer == nil {
                    let borderLayer = CALayer()
                    borderLayer.frame = bounds.insetBy(dx: 1.5, dy: 1.5)
                    borderLayer.borderWidth = 3
                    borderLayer.borderColor = colorView.backgroundColor?.cgColor
                    borderLayer.opacity = 0.3
                    borderLayer.cornerRadius = 12
                    layer.addSublayer(borderLayer)
                    selectedBorderLayer = borderLayer
                }
            } else {
                selectedBorderLayer?.removeFromSuperlayer()
                selectedBorderLayer = nil
            }
        }
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(colorView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
}
