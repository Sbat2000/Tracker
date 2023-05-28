//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 26.05.2023.
//

import UIKit

final class SelectTypeTrackerViewController: UIViewController {
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Создание трекера"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let habitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(habitButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.backgroundColor = .blackDay
        button.setTitle("Привычка", for: .normal)
        return button
    }()
    
    let eventButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = .blackDay
        button.setTitle("Нерегулярные событие", for: .normal)
        button.addTarget(self, action: #selector(eventButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        view.backgroundColor = .whiteDay
        view.addSubview(headerLabel)
        view.addSubview(habitButton)
        view.addSubview(eventButton)
    }
    
    @objc
    private func habitButtonPressed() {
        let vc = CreateTrackerViewController(type: .habits)
        present(vc, animated: true)
    }
    
    @objc
    private func eventButtonPressed() {
        let vc = CreateTrackerViewController(type: .event)
        present(vc, animated: true)
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            habitButton.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 295),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            eventButton.leadingAnchor.constraint(equalTo: habitButton.leadingAnchor),
            eventButton.trailingAnchor.constraint(equalTo: habitButton.trailingAnchor),
            eventButton.heightAnchor.constraint(equalTo: habitButton.heightAnchor)
            
            
        ])
    }
    
}
