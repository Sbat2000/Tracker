

import UIKit

final class TrackersViewController: UIViewController {
    
    let arrayOfEmoji = [ "🍇", "🍈", "🍉", "🍊", "🍋", "🍌", "🍍", "🥭", "🍎", "🍏", "🍐", "🍒", "🍓", "🫐", "🥝", "🍅", "🫒", "🥥", "🥑", "🍆", "🥔", "🥕", "🌽", "🌶️", "🫑", "🥒", "🥬", "🥦", "🧄", "🧅", "🍄",
                         "🍇", "🍈", "🍉", "🍊", "🍋", "🍌", "🍍", "🥭", "🍎", "🍏", "🍐", "🍒", "🍓", "🫐", "🥝", "🍅", "🫒", "🥥", "🥑", "🍆", "🥔", "🥕", "🌽", "🌶️", "🫑", "🥒", "🥬", "🥦", "🧄", "🧅", "🍄",
                         "🍇", "🍈", "🍉", "🍊", "🍋", "🍌", "🍍", "🥭", "🍎", "🍏", "🍐", "🍒", "🍓", "🫐", "🥝", "🍅", "🫒", "🥥", "🥑", "🍆", "🥔", "🥕", "🌽", "🌶️", "🫑", "🥒", "🥬", "🥦", "🧄", "🧅", "🍄"]
    
    
    private lazy var trackersHome: [Tracker] = [
        Tracker(id: 0, name: "Погулять с собакой", color: Resources.Colors.Sections.colorSection1, emoji: "🐕", schedule: nil),
        Tracker(id: 1, name: "Пропылесосить", color: Resources.Colors.Sections.colorSection2, emoji: "🐷", schedule: nil),
        Tracker(id: 2, name: "Приготовить покушать", color: Resources.Colors.Sections.colorSection3, emoji: "🍒", schedule: nil),
        
    ]
    
    private lazy var anotherTrackers: [Tracker] = [
        Tracker(id: 2, name: "Накоримить уток", color: Resources.Colors.Sections.colorSection4, emoji: "🐤", schedule: nil),
        Tracker(id: 2, name: "Найти жирафа", color: Resources.Colors.Sections.colorSection5, emoji: "🦒", schedule: nil),
        Tracker(id: 2, name: "Накоримить уток", color: Resources.Colors.Sections.colorSection4, emoji: "🐤", schedule: nil),
        Tracker(id: 2, name: "Найти жирафа", color: Resources.Colors.Sections.colorSection5, emoji: "🦒", schedule: nil),
        Tracker(id: 2, name: "Накоримить уток", color: Resources.Colors.Sections.colorSection4, emoji: "🐤", schedule: nil),
        Tracker(id: 2, name: "Найти жирафа", color: Resources.Colors.Sections.colorSection5, emoji: "🦒", schedule: nil),
    ]
    
    private lazy var categories = [
        TrackerCategory(header: "Домашние дела", trackers: trackersHome),
        TrackerCategory(header: "Другое", trackers: anotherTrackers)
    ]
    
    
    
    private lazy var searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.placeholder = "Поиск"
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
    }()
    
    private lazy var trackersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupCell()
        setupLayout()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        view.addSubview(searchTextField)
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
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
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
}

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        categories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCollectionViewCell.reuseIdentifier, for: indexPath) as! TrackersCollectionViewCell
        let tracker = categories[indexPath.section].trackers[indexPath.item]
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
            let category = categories[indexPath.section]
            headerView.titleLabel.text = category.header
            return headerView
            
        }
        return UICollectionReusableView()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}

