
import Foundation

final class StatsViewModel {
    func getCompletedTrackers() -> Int {
        DataProvider.shared.getCompletedTrackers()
    }
}
