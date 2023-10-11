//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 26.05.2023.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    private let dayArray = [NSLocalizedString("monday", comment: ""),
                            NSLocalizedString("tuesday", comment: ""),
                            NSLocalizedString("wednesday", comment: ""),
                            NSLocalizedString("thursday", comment: ""),
                            NSLocalizedString("friday", comment: ""),
                            NSLocalizedString("saturday", comment: ""),
                            NSLocalizedString("sunday", comment: "")
    ]
    

    weak var delegate: ScheduleViewControllerDelegate?
    private let trackerCreateService = DataProvider.shared
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Расписание"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var readyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = .blackDay
        button.setTitleColor(.whiteDay, for: .normal)
        button.setTitle("Готово", for: .normal)
        button.addTarget(self, action: #selector(readyButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView:UITableView = {
        let table = UITableView(frame: view.bounds)
        table.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
        table.layer.cornerRadius = 10
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return table
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        view.backgroundColor = .whiteDay
        view.addSubview(headerLabel)
        view.addSubview(tableView)
        view.addSubview(readyButton)
        
        
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            readyButton.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
            tableView.bottomAnchor.constraint(equalTo: readyButton.topAnchor, constant: -8)
            
        ])
    }
    
    private func setupCornerRadiusCell(for cell: ScheduleCell, indexPath: IndexPath) -> ScheduleCell {
        if indexPath.row == 0 {
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if indexPath.row == 6 {
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
        }
        return cell
    }
    
    @objc
    private func readyButtonPressed() {
        dismiss(animated: true)
    }
    
}

extension ScheduleViewController: UITableViewDelegate {
    
}


extension ScheduleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(75)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.reuseIdentifier, for: indexPath) as! ScheduleCell
        cell.delegate = self
        setupCornerRadiusCell(for: cell, indexPath: indexPath)
        cell.headerLabel.text = dayArray[indexPath.row]
        let day = indexPath.row + 1
            if trackerCreateService.scheduleContains(day) {
                cell.switchControl.isOn = true
            }
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


extension ScheduleViewController: ScheduleCellDelegate {
    func scheduleCell(_ cell: ScheduleCell, didChangeSwitchValue isOn: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let day = indexPath.row + 1
        if isOn {
            trackerCreateService.addDay(day: day)
            delegate?.scheduleChanged()
        } else {
            trackerCreateService.removeDay(day: day)
            delegate?.scheduleChanged()
        }     
    }
}
