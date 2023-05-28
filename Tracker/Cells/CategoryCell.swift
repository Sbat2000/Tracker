//
//  CategoryCell.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 27.05.2023.
//

import UIKit

final class CategoryCell: UITableViewCell {
    
    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
        
    }
    
    private func setupUI() {
        backgroundColor = .backgroundDay
        addSubview(label)
    }
    
    private func setupLayout() {
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
