

import Foundation

final class CategoryViewModel {
    @Observable var categoryArray: [String] = []
    var selectedIndexPath: IndexPath?
    
    init() {
        categoryArray = DataProvider.shared.getCategories()
        DataProvider.shared.delegate = self
    }
    
    var categoriesCount: Int {
        categoryArray.count
    }
    
    func getCategory(at index: Int) -> String {
        categoryArray[index]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        selectedIndexPath = indexPath
        if !categoryArray.isEmpty {
            let category = categoryArray[indexPath.row]
            DataProvider.shared.setCategory(category: category)
        }
    }
    
    func cellIsSelected(at indexPath: IndexPath) -> Bool {
        selectedIndexPath == indexPath
    }
    
    func clearSelection() {
        selectedIndexPath = nil
    }
    
    func updateData() {
        categoryArray = DataProvider.shared.getCategories()
    }
    
}

extension CategoryViewModel: DataProviderDelegate {
    func updateCategories() {
        categoryArray = DataProvider.shared.getCategories()
    }
    
    func addTrackers() {
        
    }
    
    func updateCategories(_ newCategory: [TrackerCategory]) {
        
    }
    
    func updateRecords(_ newRecords: Set<TrackerRecord>) {
        
    }
    
    
}
