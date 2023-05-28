//
//  CategoryCell.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 27.05.2023.
//

import UIKit

final class CategoryCell: UITableViewCell {
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        backgroundColor = .backgroundDay
        addSubview(headerLabel)
    }
    
    private func setupLayout() {

        NSLayoutConstraint.activate([
            
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
