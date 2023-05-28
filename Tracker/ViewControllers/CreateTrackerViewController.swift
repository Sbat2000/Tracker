//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 26.05.2023.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    
    private let trackerCreateService = TrackerCreateService.shared
    private var arrayOfButtons: [String] {
        return type.arrayOfButtons
    }
    
    var type: `Type`
    
    enum `Type` {
        case habits
        case event
        
        var arrayOfButtons: [String] {
            switch self {
            case .habits: return ["Категория", "Расписание"]
            case .event: return ["Категория"]
            }
        }
        
    }
    
    init(type: `Type`) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        textField.textColor = .blackDay
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.placeholder = "Введите название трекера"
        textField.layer.cornerRadius = 16
        return textField
    }()
    
    private lazy var tableView:UITableView = {
        let table = UITableView(frame: view.bounds)
        table.register(CreateCell.self, forCellReuseIdentifier: CreateCell.reuseIdentifier)
        table.layer.cornerRadius = 10
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return table
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

    private func setupBottomButtonsStack() {
        bottomButtonsStack.addArrangedSubview(cancelButton)
        bottomButtonsStack.addArrangedSubview(createButton)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(headerLabel)
        view.addSubview(trackerHeaderTextField)
        view.addSubview(tableView)
        setupBottomButtonsStack()
        view.addSubview(bottomButtonsStack)
    }
    
    private func setupCornerRadiusCell(for cell: CreateCell, indexPath: IndexPath) -> CreateCell {
        if indexPath.row == 0 {
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        if indexPath.row == (arrayOfButtons.count - 1)  {
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
        }
        return cell
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
    
    private func scheduleButtonPressed() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.delegate = self
        present(scheduleVC, animated: true)
    }
    
    
    private func categoryButtonPressed() {
        let categoryVC = CategoryViewController()
        categoryVC.delegate = self
        present(categoryVC, animated: true)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            trackerHeaderTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
            trackerHeaderTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerHeaderTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerHeaderTextField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: trackerHeaderTextField.bottomAnchor, constant: 38),
            tableView.bottomAnchor.constraint(equalTo: bottomButtonsStack.topAnchor, constant: -8),
            
            bottomButtonsStack.leadingAnchor.constraint(equalTo: trackerHeaderTextField.leadingAnchor),
            bottomButtonsStack.trailingAnchor.constraint(equalTo: trackerHeaderTextField.trailingAnchor),
            bottomButtonsStack.heightAnchor.constraint(equalToConstant: 60),
            bottomButtonsStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34)
        ])
    }
}

extension CreateTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfButtons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreateCell.reuseIdentifier, for: indexPath) as! CreateCell
        cell.headerLabel.text = arrayOfButtons[indexPath.row]
        if indexPath.row == 0 {
            cell.subLabel.text = trackerCreateService.category
        }
        if indexPath.row == 1 {
            cell.subLabel.text = trackerCreateService.getFormattedSchedule()
        }
        setupCornerRadiusCell(for: cell, indexPath: indexPath)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            categoryButtonPressed()
        } else if indexPath.row == 1 {
            scheduleButtonPressed()
        }
    }
}

extension CreateTrackerViewController: CategoryViewControllerDelegate {
    func didSelectCategory(_ category: String?) {
        tableView.reloadData()
    }
}

extension CreateTrackerViewController: ScheduleViewControllerDelegate {
    func scheduleChanged() {
        tableView.reloadData()
    }
}
