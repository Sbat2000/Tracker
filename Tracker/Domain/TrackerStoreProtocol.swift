import Foundation

protocol TrackerStoreProtocol: AnyObject {
    func addTracker(model: Tracker)
    func fetchTrackers() -> [TrackerCategory]
}
