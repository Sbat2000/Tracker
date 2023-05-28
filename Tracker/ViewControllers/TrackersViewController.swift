

import UIKit

final class TrackersViewController: UIViewController {
    
    private let trackerCreateService = TrackerCreateService.shared
    private var currentDate = Date()
    private var day = 1
    private var query: String = ""
    var datePicker: UIDatePicker?
    
    private lazy var trackersHome: [Tracker] = [
        Tracker(name: "Погулять с собакой", color: Resources.Colors.Sections.colorSection1, emoji: "🐕", schedule:  []),
        Tracker(name: "Пропылесосить", color: Resources.Colors.Sections.colorSection2, emoji: "🐷", schedule: []),
        Tracker(name: "Приготовить покушать", color: Resources.Colors.Sections.colorSection3, emoji: "🍒", schedule: []),
        
    ]
    
    private lazy var anotherTrackers: [Tracker] = [
        Tracker(name: "Накоримить уток", color: Resources.Colors.Sections.colorSection4, emoji: "🐤", schedule: []),
        Tracker(name: "Найти жирафа", color: Resources.Colors.Sections.colorSection5, emoji: "🦒", schedule: []),
        Tracker(name: "Накоримить уток", color: Resources.Colors.Sections.colorSection4, emoji: "🐤", schedule: []),
        Tracker(name: "Найти жирафа", color: Resources.Colors.Sections.colorSection5, emoji: "🦒", schedule: []),
        Tracker(name: "Накоримить уток", color: Resources.Colors.Sections.colorSection4, emoji: "🐤", schedule: []),
        Tracker(name: "Найти жирафа", color: Resources.Colors.Sections.colorSection5, emoji: "🦒", schedule: []),
    ]
    
    private lazy var categories = [
        TrackerCategory(header: "Домашние дела", trackers: trackersHome),
        TrackerCategory(header: "Важное", trackers: anotherTrackers)
    ]
    
    
    private lazy var visibleCategories = [TrackerCategory]()
    
    
    private lazy var searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.placeholder = "Поиск"
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
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
        initialDay()
        trackerCreateService.delegate = self
        searchTextField.delegate = self
        query = searchTextField.text ?? ""
        view.backgroundColor = .systemBackground
        setupUI()
        setupCell()
        setupLayout()
        setupDatePicker()
        updateVisibleCategories(categories)
    }
    
    private func setupUI() {
        view.addSubview(searchTextField)
        view.addSubview(placeholder)
        view.addSubview(label)
        view.addSubview(trackersCollectionView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            trackersCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
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
    
    private func updateVisibleCategories(_ newCategory: [TrackerCategory]) {
        visibleCategories = newCategory
        trackersCollectionView.reloadData()
        placeholder.image = .notFound
        label.text = "Ничего не найдено"
        updateCollectionViewVisibility()
    }
    
    
    private func updateCollectionViewVisibility() {
        let hasData = !visibleCategories.isEmpty
        trackersCollectionView.isHidden = !hasData
        placeholder.isHidden = hasData
    }
    
    func presentSelectTypeVC() {
        let selectTypeVC = SelectTypeTrackerViewController()
        present(selectTypeVC, animated: true)
    }
}

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
        print("width CELL: \(width)")
        let height = width * 0.887
        print("height CELL: \(height)")
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

extension TrackersViewController: TrackerCreateServiceDelegate {
    func addTrackers(trackersCategory: TrackerCategory) {
        let header = trackersCategory.header
        if let index = categories.firstIndex { $0.header == header} {
            let array  = categories[index].trackers + trackersCategory.trackers
            let trackerCategory = TrackerCategory(header: header, trackers: array)
            categories[index] = trackerCategory
            updateVisibleCategories(categories)
            filtered()
            dismissAllModalControllers(from: self)
        } else  {
            categories.append(trackersCategory)
            updateVisibleCategories(categories)
            filtered()
            dismissAllModalControllers(from: self)
        }
    }
}


//MARK: - UITextFieldDelegate
extension TrackersViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let queryTextFiled = textField.text else { return }
        query = queryTextFiled
        filtered()
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
        print("Категории внутри фильтра \(filteredCategories)")
        updateVisibleCategories(filteredCategories)
    }
}
