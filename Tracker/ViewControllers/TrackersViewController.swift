

import UIKit

final class TrackersViewController: UIViewController {
    
    private let dataProvider = DataProvider.shared
    private var currentDate = Date()
    private let todayDate = Date()
    private var day = 1
    private var query: String = ""
    var datePicker: UIDatePicker?
    private var completedTrackers: Set<TrackerRecord> = []

    private lazy var categories: [TrackerCategory] = []
    private lazy var visibleCategories = [TrackerCategory]()
    
    lazy var searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.placeholder = "Поиск"
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.clearButtonMode = .never
        return searchTextField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отменить", for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var placeholder: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = .placeHolder
        return image
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .blackDay
        label.text = "Что будем отслеживать?"
        return label
    }()
    
    private lazy var trackersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataProvider.shared.setMainCategory()
        categories = dataProvider.getTrackers()
        updateVisibleCategories(categories)
        initialDay()
        dataProvider.delegate = self
        DataProvider.shared.updateRecords()
        searchTextField.delegate = self
        query = searchTextField.text ?? ""
        view.backgroundColor = .systemBackground
        setupUI()
        setupCell()
        setupLayout()
        setupDatePicker()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
        
    private func setupSearchContainerView() {
        searchContainerView.addArrangedSubview(searchTextField)
        searchContainerView.addArrangedSubview(cancelButton)
        cancelButton.isHidden = true
    }
    
    private func setupUI() {
        setupSearchContainerView()
        view.addSubview(searchContainerView)
        view.addSubview(placeholder)
        view.addSubview(label)
        view.addSubview(trackersCollectionView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            searchContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            cancelButton.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor),
            cancelButton.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            
            trackersCollectionView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 10),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            placeholder.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: placeholder.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupCell() {
        trackersCollectionView.delegate = self
        trackersCollectionView.dataSource = self
        trackersCollectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.reuseIdentifier)
        trackersCollectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
    }
    
    private func setupUICell(_ cell: TrackersCollectionViewCell, withTracker tracker: Tracker) {
        cell.emojiLabel.text = tracker.emoji
        cell.trackerTextLabel.text = tracker.name
        cell.colorView.backgroundColor = tracker.color
        cell.trackerCompleteButton.backgroundColor = tracker.color
        cell.trackerCompleteButton.addTarget(self, action: #selector(trackerCompleteButtonTapped(_:)), for: .touchUpInside)
        let trackerRecord = createTrackerRecord(with: tracker.id)
        let isCompleted = completedTrackers.contains(trackerRecord)
        cell.counterTextLabel.text = setupCounterTextLabel(trackerID: trackerRecord.id)
        if Date() < currentDate && !tracker.schedule.isEmpty {
            cell.trackerCompleteButton.isUserInteractionEnabled = false
        } else {
            cell.trackerCompleteButton.isUserInteractionEnabled = true
        }
        cell.trackerCompleteButton.toggled = isCompleted
    }
    
    private func createTrackerRecord(with id: UUID) -> TrackerRecord {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let date = dateFormatter.string(from: currentDate)
        let trackerRecord = TrackerRecord(id: id, date: date)
        return trackerRecord
    }
    
    private func dismissAllModalControllers(from viewController: UIViewController) {
        if let presentedViewController = viewController.presentedViewController {
            viewController.dismiss(animated: true, completion: nil)
            dismissAllModalControllers(from: presentedViewController)
        }
    }
    
    private func setupDatePicker() {
        datePicker?.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        datePicker?.calendar = calendar
    }
    
    @objc
    private func dateChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        let calendar = Calendar.current
        let weekday: Int = {
            let day = calendar.component(.weekday, from: currentDate) - 1
            if day == 0 { return 7 }
            return day
        }()
        day = weekday
        filtered()
        setupPlaceHolder()
    }
    
    @objc
    private func cancelButtonTapped() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
    }
    
    @objc
    private func trackerCompleteButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? TrackersCollectionViewCell,
              let indexPath = trackersCollectionView.indexPath(for: cell) else { return }
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.item]
        guard currentDate < Date() || tracker.schedule.isEmpty else { return }
        let trackerRecord = createTrackerRecord(with: tracker.id)
        if completedTrackers.contains(trackerRecord) {
            DataProvider.shared.deleteRecord(trackerRecord)
        } else {
            DataProvider.shared.addRecord(trackerRecord)
        }
        cell.counterTextLabel.text = setupCounterTextLabel(trackerID: tracker.id)
    }
    
    private func setupCounterTextLabel(trackerID: UUID) -> String {
        let count = completedTrackers.filter { $0.id == trackerID }.count
        var text: String
        text = count.days()
        return("\(text)")
    }
    
    private func initialDay() {
        let calendar = Calendar.current
        let weekday: Int = {
            let day = calendar.component(.weekday, from: currentDate) - 1
            if day == 0 { return 7 }
            return day
        }()
        day = weekday
        filtered()
    }
    
    internal func updateVisibleCategories(_ newCategory: [TrackerCategory]) {
        visibleCategories = newCategory
        trackersCollectionView.reloadData()
        updateCollectionViewVisibility()
    }
    
    private func setupPlaceHolder() {
        if visibleCategories.isEmpty  {
            placeholder.image = .notFound
            label.text = "Ничего не найдено"
        }
    }
    
    
    private func updateCollectionViewVisibility() {
        let hasData = !visibleCategories.isEmpty
        trackersCollectionView.isHidden = !hasData
        placeholder.isHidden = hasData
    }
    
    func presentSelectTypeVC() {
        let selectTypeVC = SelectTypeTrackerViewController()
        searchTextField.endEditing(true)
        present(selectTypeVC, animated: true)
    }
}

//MARK: - UICollectionViewDataSource & Delegate

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCollectionViewCell.reuseIdentifier, for: indexPath) as! TrackersCollectionViewCell
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.item]
        setupUICell(cell, withTracker: tracker)
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (trackersCollectionView.bounds.width - 9) / 2
        let height = width * 0.887
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
            let category = visibleCategories[indexPath.section]
            headerView.titleLabel.text = category.header
            return headerView
            
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}

//MARK: - DataProviderDelegate

extension TrackersViewController: DataProviderDelegate {
    func updateCategories(_ newCategory: [TrackerCategory]) {
        categories = newCategory
        updateVisibleCategories(categories)
    }

    func addTrackers() {
        updateVisibleCategories(categories)
        filtered()
        dismissAllModalControllers(from: self)
    }
    
    func updateRecords(_ newRecords: Set<TrackerRecord>) {
        completedTrackers = newRecords
    }
}


//MARK: - UITextFieldDelegate

extension TrackersViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let queryTextFiled = textField.text else { return }
        query = queryTextFiled
        filtered()
        setupPlaceHolder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.cancelButton.isHidden = false
            self.view.layoutIfNeeded()
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.cancelButton.isHidden = true
            self.view.layoutIfNeeded()
            
        }
        if categories.isEmpty {
            placeholder.image = .placeHolder
            label.text = "Что будем отслеживать?"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
}

//MARK: - Filters cells

extension TrackersViewController {
    private func filtered() {
        var filteredCategories = [TrackerCategory]()
        
        for category in categories {
            var trackers = [Tracker]()
            for tracker in category.trackers {
                let schedule = tracker.schedule
                if schedule.contains(day) {
                    trackers.append(tracker)
                } else if schedule.isEmpty {
                    trackers.append(tracker)
                }
                
            }
            if !trackers.isEmpty {
                let trackerCategory = TrackerCategory(header: category.header, trackers: trackers)
                filteredCategories.append(trackerCategory)
            }
        }
        
        if !query.isEmpty {
            var trackersWithFilteredName = [TrackerCategory]()
            for category in filteredCategories {
                var trackers = [Tracker]()
                for tracker in category.trackers {
                    let trackerName = tracker.name.lowercased()
                    if trackerName.range(of: query, options: .caseInsensitive) != nil {
                        trackers.append(tracker)
                    }
                }
                if !trackers.isEmpty {
                    let trackerCategory = TrackerCategory(header: category.header, trackers: trackers)
                    trackersWithFilteredName.append(trackerCategory)
                }
            }
            filteredCategories = trackersWithFilteredName
        }
        updateVisibleCategories(filteredCategories)
    }
}
