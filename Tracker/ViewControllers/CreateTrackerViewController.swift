//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 26.05.2023.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    
    private let trackerCreateService = TrackerCreateService.shared
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Новая привычка"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var trackerHeaderTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .backgroundDay
        textField.textColor = .ypGray
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.placeholder = "Введите название трекера"
        textField.layer.cornerRadius = 16
        return textField
    }()
    
    private lazy var setupTrackerButtonsStack: UIStackView =  {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 16
        stackView.backgroundColor = .backgroundDay
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypGray
        return view
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Категория", for: .normal)
        button.setTitleColor(.blackDay, for: .normal)
        button.tintColor = .ypGray
        let image = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 12))
        
        button.setImage(image, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(categoryButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var scheduleButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Расписание", for: .normal)
        button.setTitleColor(.blackDay, for: .normal)
        button.tintColor = .ypGray
        let image = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 12))
        button.setImage(image, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(scheduleButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypGray
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.whiteDay
                             , for: .normal)
        button.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let bottomButtonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
    
    private func setupSetupTrackerButtonsStack() {
        setupTrackerButtonsStack.addArrangedSubview(categoryButton)
        setupTrackerButtonsStack.addArrangedSubview(separatorView)
        setupTrackerButtonsStack.addArrangedSubview(scheduleButton)
    }
    
    private func setupBottomButtonsStack() {
        bottomButtonsStack.addArrangedSubview(cancelButton)
        bottomButtonsStack.addArrangedSubview(createButton)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(headerLabel)
        view.addSubview(trackerHeaderTextField)
        setupSetupTrackerButtonsStack()
        setupBottomButtonsStack()
        view.addSubview(setupTrackerButtonsStack)
        view.addSubview(bottomButtonsStack)
    }
    
    @objc
    private func dismissSelf() {
        dismiss(animated: true)
    }
    
    @objc
    private func createButtonPressed() {
        let title = trackerHeaderTextField.text ?? "Не ввели название"
        trackerCreateService.createTracker(title: title)
    }
    
    @objc
    private func scheduleButtonPressed() {
        present(ScheduleViewController(), animated: true)
    }
    
    @objc
    private func categoryButtonPressed() {
        present(CategoryViewController(), animated: true)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            trackerHeaderTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
            trackerHeaderTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerHeaderTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerHeaderTextField.heightAnchor.constraint(equalToConstant: 75),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            //categoryButton.heightAnchor.constraint(equalToConstant: 75),
            //scheduleButton.heightAnchor.constraint(equalToConstant: 75),
            
            
            setupTrackerButtonsStack.topAnchor.constraint(equalTo: trackerHeaderTextField.bottomAnchor, constant: 24),
            setupTrackerButtonsStack.leadingAnchor.constraint(equalTo: trackerHeaderTextField.leadingAnchor),
            setupTrackerButtonsStack.trailingAnchor.constraint(equalTo: trackerHeaderTextField.trailingAnchor),
            setupTrackerButtonsStack.heightAnchor.constraint(equalToConstant: 151),
            
            bottomButtonsStack.leadingAnchor.constraint(equalTo: trackerHeaderTextField.leadingAnchor),
            bottomButtonsStack.trailingAnchor.constraint(equalTo: trackerHeaderTextField.trailingAnchor),
            bottomButtonsStack.heightAnchor.constraint(equalToConstant: 60),
            bottomButtonsStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34)
            
   
        ])
    }
}
