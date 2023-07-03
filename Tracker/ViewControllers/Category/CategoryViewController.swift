//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 27.05.2023.
//

import UIKit

final class CategoryViewController: UIViewController {
    private var categoryViewModel: CategoryViewModel!
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = .blackDay
        button.setTitleColor(.whiteDay, for: .normal)
        button.setTitle("Добавить категорию", for: .normal)
        button.addTarget(self, action: #selector(addCategoryButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView:UITableView = {
        let table = UITableView(frame: view.bounds)
        table.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
        table.layer.cornerRadius = 10
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryViewModel = CategoryViewModel()
        setupUI()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = categoryViewModel.selectedIndexPath {
            tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .none)
            tableView(tableView, didSelectRowAt: selectedIndexPath)
        }
    }
    
    @objc
    private func addCategoryButtonPressed() {
        let vc = CreateCategoryViewController()
        vc.viewModel = CreateCategoryViewModel()
        vc.viewModel?.delegate = self
        present(vc, animated: true)
    }
    
    private func bind() {
        categoryViewModel.$categoryArray.bind {[weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    private func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = .whiteDay
        view.addSubview(headerLabel)
        view.addSubview(tableView)
        view.addSubview(addCategoryButton)
        bind()
    }
    
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -8)
            
        ])
    }
    
    private func setupCornerRadiusCell(for cell: CategoryCell, indexPath: IndexPath) -> CategoryCell {
        if indexPath.row == 0 {
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        if indexPath.row == (categoryViewModel.categoriesCount - 1)  {
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
        }
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {
    
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryViewModel.categoriesCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as! CategoryCell
        if categoryViewModel.cellIsSelected(at: indexPath) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.selectionStyle = .none
        cell.viewModel = categoryViewModel.getCategory(at: indexPath.row)
        setupCornerRadiusCell(for: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryViewModel.didSelectRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        categoryViewModel.clearSelection()
        tableView.reloadData()
    }
    
}

extension CategoryViewController: CreateCategoryViewModelDelegate {
    func updateCategory() {
        categoryViewModel.updateData()
    }
}
