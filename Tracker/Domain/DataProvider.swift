import UIKit

final class DataProvider {
    
    static let shared = DataProvider()
    
    private init() { }
    
    private lazy var trackerStore =  TrackerStore()
    private lazy var trackerCategoryStore = TrackerCategoryStore()
    private lazy var trackerRecordStore = TrackerRecordStore()
    
    weak var delegate: DataProviderDelegate?
    var emoji = ""
    var color: UIColor = .black
    @Observable
    var category: String = "Важное"
    var title = ""
    var schedule: [Int] = []
    
    private var visibleCategories: [TrackerCategory]?
    private var completedTrackers: [TrackerRecord]?
    
    let arrayOfEmoji = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    let arrayOfColors: [UIColor] = [.colorSection1,
                                    .colorSection2,
                                    .colorSection3,
                                    .colorSection4,
                                    .colorSection5,
                                    .colorSection6,
                                    .colorSection7,
                                    .colorSection8,
                                    .colorSection9,
                                    .colorSection10,
                                    .colorSection11,
                                    .colorSection12,
                                    .colorSection13,
                                    .colorSection14,
                                    .colorSection15,
                                    .colorSection16,
                                    .colorSection17,
                                    .colorSection18,]
    
   private let shortDayArray = [NSLocalizedString("mo", comment: ""),
                                NSLocalizedString("tu", comment: ""),
                                NSLocalizedString("we", comment: ""),
                                NSLocalizedString("th", comment: ""),
                                NSLocalizedString("fr", comment: ""),
                                NSLocalizedString("sa", comment: ""),
                                NSLocalizedString("su", comment: "")]
    
    func updateCategories() {
        let category = trackerStore.fetchTrackers()
        delegate?.updateCategories(category)
    }
    
    func setCategory(category: String) {
        self.category = category
    }
    
    func addDay(day: Int){
        schedule.append(day)
    }
    
    func removeDay(day: Int) {
        schedule.removeAll { $0 == day }
    }
    
    func scheduleContains(_ day: Int) -> Bool {
        schedule.contains(day)
    }
 
    func createTracker() {
        let tracker = Tracker(id: UUID(),
                              name: title,
                              color: self.color,
                              emoji: emoji,
                              schedule: schedule,
                              pinned: false)
        trackerStore.addTracker(model: tracker)
        delegate?.addTrackers()
        clean()
    }
    
    func deleteTracker(model: Tracker) {
        trackerStore.deleteTacker(model: model)
    }
    
    func pinTracker(model: Tracker) {
        trackerStore.pinTacker(model: model)
    }
    //TODO: - переделать на нормальное редактирование
    func updateTracker(model: Tracker) {
        trackerStore.deleteTacker(model: model)
        let tracker = Tracker(id: model.id,
                              name: title,
                              color: self.color,
                              emoji: emoji,
                              schedule: schedule,
                              pinned: false)
        trackerStore.addTracker(model: tracker)
        delegate?.addTrackers()
        clean()
    }
    
    //MARK: - trackerCategoryStore
    
    func addCategory(header: String) {
        trackerCategoryStore.addCategory(header: header)
    }
    
    func getTrackers() -> [TrackerCategory] {
        trackerStore.fetchTrackers()
    }
    
    func getCategories() -> [String] {
        trackerCategoryStore.getCategories()
    }
    
    func setMainCategory() {
        trackerCategoryStore.setMainCategory()
    }
    
    func updateButtonEnabled() -> Bool {
        if !emoji.isEmpty && color != .black && !title.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func deleteCategory(at header: String) {
        trackerCategoryStore.deleteCategory(at: header)
    }
    
    //MARK: - TreckerRecord
    
    func updateRecords() {
        let newRecords = trackerRecordStore.getRecords()
        delegate?.updateRecords(newRecords)
    }
    
    func addRecord(_ record: TrackerRecord) {
        trackerRecordStore.addTrackerRecord(record)
        let currentCount = UserDefaults.standard.integer(forKey: "completedTrackers")
        let newCount = currentCount + 1
        UserDefaults.standard.set(newCount, forKey: "completedTrackers")
    }
    
    func deleteRecord(_ record: TrackerRecord) {
        trackerRecordStore.deleteTrackerRecord(record)
        let currentCount = UserDefaults.standard.integer(forKey: "completedTrackers")
            let newCount = max(currentCount - 1, 0)
            UserDefaults.standard.set(newCount, forKey: "completedTrackers")
    }
    
    func getFormattedSchedule() -> String? {
        guard !schedule.isEmpty else {
            return nil
        }
        
        let days = schedule.map { shortDayArray[$0 - 1] }
        return days.joined(separator: ", ")
    }
    
    func getCompletedTrackers() -> Int {
        let completedTrackers = UserDefaults.standard.integer(forKey: "completedTrackers")
        return completedTrackers
    }
    
    private func clean() {
        schedule = []
        color = .black
        emoji = ""
        title = ""
    }
}
