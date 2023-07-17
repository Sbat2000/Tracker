

import XCTest
import SnapshotTesting
@testable import Tracker
//во время первого теста необходимо поменять ключ "record" на true, тест провалиться, это нормально, дальше меняем на false и прогоняем тесты. Если добавляем/меняем трекеры, то надо заново перезаписать скриншот.

final class TrackerTests: XCTestCase {
    func testMainVCLight() {
        let vc = TrackersViewController()
        assertSnapshots(matching: vc, as: [.image(traits: .init(userInterfaceStyle: .light))], record: false)
    }
    
    func testMainVCDark() {
        let vc = TrackersViewController()
        assertSnapshots(matching: vc, as: [.image(traits: .init(userInterfaceStyle: .dark))], record: false)
    }

}
