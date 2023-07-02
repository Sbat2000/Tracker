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
    private var schedule: [Int] = []
    
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
    
    private let shortDayArray = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    
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
                              schedule: schedule)
        trackerStore.addTracker(model: tracker)
        delegate?.addTrackers()
        clean()
    }
    
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
    
    //MARK: - TreckerRecord
    
    func updateRecords() {
        let newRecords = trackerRecordStore.getRecords()
        delegate?.updateRecords(newRecords)
    }
    
    func addRecord(_ record: TrackerRecord) {
        trackerRecordStore.addTrackerRecord(record)
    }
    
    func deleteRecord(_ record: TrackerRecord) {
        trackerRecordStore.deleteTrackerRecord(record)
    }
    
    func getFormattedSchedule() -> String? {
        guard !schedule.isEmpty else {
            return nil
        }
        
        let days = schedule.map { shortDayArray[$0 - 1] }
        return days.joined(separator: ", ")
    }
    
    private func clean() {
        schedule = []
        color = .black
        emoji = ""
        title = ""
    }
}
