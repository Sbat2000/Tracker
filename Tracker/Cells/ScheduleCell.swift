//
//  ScheduleCell.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 26.05.2023.
//

import UIKit

final class ScheduleCell: UITableViewCell {
    
    let label = UILabel()
    weak var delegate: ScheduleCellDelegate?
    
    lazy var switchControl:UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = false
        switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        return switchControl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
        
    }
    
    private func setupUI() {
        backgroundColor = .backgroundDay
        contentView.addSubview(switchControl)
        addSubview(label)
    }
    
    private func setupLayout() {
        label.translatesAutoresizingMaskIntoConstraints = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            switchControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            switchControl.centerYAnchor.constraint(equalTo: centerYAnchor)
            
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        delegate?.scheduleCell(self, didChangeSwitchValue: sender.isOn)
    }
}
