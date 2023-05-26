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
        button.addTarget(self, action: #selector(presentCreateViewController), for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.backgroundColor = .blackDay
        button.setTitle("Привычка", for: .normal)
        return button
    }()
    
    let irregularButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = .blackDay
        button.setTitle("Нерегулярные событие", for: .normal)
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
        view.addSubview(irregularButton)
    }
    
    @objc
    private func presentCreateViewController() {
        present(CreateTrackerViewController(), animated: true)
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            habitButton.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 295),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            irregularButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            irregularButton.leadingAnchor.constraint(equalTo: habitButton.leadingAnchor),
            irregularButton.trailingAnchor.constraint(equalTo: habitButton.trailingAnchor),
            irregularButton.heightAnchor.constraint(equalTo: habitButton.heightAnchor)
            
            
        ])
    }
    
}
