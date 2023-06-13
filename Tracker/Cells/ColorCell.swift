//
//  EmojiCell.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 12.06.2023.
//


import UIKit

final class ColorCell: UICollectionViewCell {
    

    
    lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
            
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
}
