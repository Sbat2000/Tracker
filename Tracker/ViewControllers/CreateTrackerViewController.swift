import UIKit

final class CreateTrackerViewController: UIViewController {
    
    private let dataProvider = DataProvider.shared
    private var arrayOfButtons: [String] {
        return type.arrayOfButtons
    }
    private var selectedEmojiIndexPatch: IndexPath?
    private var selectedColorIndexPatch: IndexPath?
    
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
 
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
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
    
    private lazy var emojiesCollectionViewHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Emoji"
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    private lazy var emojiesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 25
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private lazy var colorsCollectionViewHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Цвет"
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    private lazy var colorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 25
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
        setupKeyboard()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
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
        
        setupScrollView()
        view.addSubview(scrollView)
        
        setupBottomButtonsStack()
        view.addSubview(bottomButtonsStack)
        trackerHeaderTextField.delegate = self
        createButton.isEnabled = false
    }
    
    private func setupScrollView() {
        setupEmojiesCollectionView()
        setupColorsCollectionView()
        scrollView.addSubview(trackerHeaderTextField)
        scrollView.addSubview(tableView)
        scrollView.addSubview(emojiesCollectionViewHeaderLabel)
        scrollView.addSubview(emojiesCollectionView)
        scrollView.addSubview(colorsCollectionViewHeaderLabel)
        scrollView.addSubview(colorsCollectionView)
    }
    
    private func setupEmojiesCollectionView() {
        emojiesCollectionView.delegate = self
        emojiesCollectionView.dataSource = self
        emojiesCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.reuseIdentifier)
    }
    
    private func setupColorsCollectionView() {
        colorsCollectionView.delegate = self
        colorsCollectionView.dataSource = self
        colorsCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
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
    
    private func bind() {
        dataProvider.$category.bind {[weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    @objc
    private func dismissSelf() {
        dismiss(animated: true)
    }
    
    @objc
    private func createButtonPressed() {
        dataProvider.createTracker()
    }
    
    private func createButtonPressedIsEnabled() {
        if DataProvider.shared.updateButtonEnabled() {
            createButton.isEnabled = true
            createButton.backgroundColor = .blackDay
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = .ypGray
        }
    }
    
    private func scheduleButtonPressed() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.delegate = self
        present(scheduleVC, animated: true)
    }
    
    
    private func categoryButtonPressed() {
        let categoryVC = CategoryViewController()
        present(categoryVC, animated: true)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
            scrollView.bottomAnchor.constraint(equalTo: bottomButtonsStack.topAnchor, constant: -16),
               
            trackerHeaderTextField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            trackerHeaderTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            trackerHeaderTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            trackerHeaderTextField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: trackerHeaderTextField.bottomAnchor, constant: 38),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(arrayOfButtons.count * 75)),
                      
            emojiesCollectionViewHeaderLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 12),
            emojiesCollectionViewHeaderLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),

            emojiesCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            emojiesCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            emojiesCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            emojiesCollectionView.topAnchor.constraint(equalTo: emojiesCollectionViewHeaderLabel.bottomAnchor, constant: 5),
            emojiesCollectionView.heightAnchor.constraint(equalToConstant: 220),
            
            colorsCollectionViewHeaderLabel.leadingAnchor.constraint(equalTo: emojiesCollectionViewHeaderLabel.leadingAnchor),
            colorsCollectionViewHeaderLabel.topAnchor.constraint(equalTo: emojiesCollectionView.bottomAnchor, constant: 16),

            colorsCollectionView.leadingAnchor.constraint(equalTo: emojiesCollectionView.leadingAnchor),
            colorsCollectionView.trailingAnchor.constraint(equalTo: emojiesCollectionView.trailingAnchor),
            colorsCollectionView.topAnchor.constraint(equalTo: colorsCollectionViewHeaderLabel.bottomAnchor, constant: 5),
            colorsCollectionView.heightAnchor.constraint(equalTo: emojiesCollectionView.heightAnchor),
            colorsCollectionView.widthAnchor.constraint(equalTo: emojiesCollectionView.widthAnchor),
            colorsCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            
            bottomButtonsStack.leadingAnchor.constraint(equalTo: trackerHeaderTextField.leadingAnchor),
            bottomButtonsStack.trailingAnchor.constraint(equalTo: trackerHeaderTextField.trailingAnchor),
            bottomButtonsStack.heightAnchor.constraint(equalToConstant: 60),
            bottomButtonsStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34)
        ])
    }
}

//MARK: - UITableViewDelegate

extension CreateTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrayOfButtons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreateCell.reuseIdentifier, for: indexPath) as! CreateCell
        cell.headerLabel.text = arrayOfButtons[indexPath.row]
        if indexPath.row == 0 {
            cell.subLabel.text = dataProvider.category
        }
        if indexPath.row == 1 {
            cell.subLabel.text = dataProvider.getFormattedSchedule()
        }
        setupCornerRadiusCell(for: cell, indexPath: indexPath)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 75
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

//MARK: - CollectionViewDelegate

extension CreateTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiesCollectionView {
            return dataProvider.arrayOfEmoji.count
        } else if collectionView == colorsCollectionView {
            return dataProvider.arrayOfColors.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.reuseIdentifier, for: indexPath) as! EmojiCell
            cell.label.text = dataProvider.arrayOfEmoji[indexPath.row]
            return cell
        } else if collectionView == colorsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier, for: indexPath) as! ColorCell
            cell.colorView.backgroundColor = dataProvider.arrayOfColors[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
}

extension CreateTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (emojiesCollectionView.bounds.width - 14 ) / 6
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiesCollectionView {
            if let selectedEmojiIndexPatch = selectedEmojiIndexPatch, let previousCell = collectionView.cellForItem(at: selectedEmojiIndexPatch) as? EmojiCell
            {
                previousCell.isSelected = false
                previousCell.colorView.backgroundColor = .clear
            }
            
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell
            cell?.isSelected = true
            cell?.colorView.backgroundColor = .lightGray
            if let emoji = cell?.label.text {
                dataProvider.emoji = emoji
            }
            createButtonPressedIsEnabled()
            selectedEmojiIndexPatch = indexPath
        } else if collectionView == colorsCollectionView {
            if let selectedIndexPath = selectedColorIndexPatch, let previousCell = collectionView.cellForItem(at: selectedIndexPath) as? ColorCell
            {
                previousCell.isSelected = false
            }
            
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCell
            cell?.isSelected = true
            if let color = cell?.colorView.backgroundColor {
                dataProvider.color = color
            }
            createButtonPressedIsEnabled()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let selectedIndexPath = emojiesCollectionView.indexPathsForSelectedItems?.first {
            emojiesCollectionView.deselectItem(at: selectedIndexPath, animated: false)
        }
    }
}

//MARK: - UITextFieldDelegate

extension CreateTrackerViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let queryTextFiled = trackerHeaderTextField.text else { return }
        DataProvider.shared.title = queryTextFiled
        createButtonPressedIsEnabled()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        trackerHeaderTextField.resignFirstResponder()
        return true
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func setupKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}
