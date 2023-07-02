

import Foundation

final class CreateCategoryViewModel {
    
    @Observable
    private(set) var isCreateButtonEnabled: Bool = false
    
    weak var delegate: CreateCategoryViewModelDelegate?
    
    func didEnter(header: String?) {
        guard let header else { return }
        let enabled = header != ""
        isCreateButtonEnabled = enabled
    }
    
    func createButtonPressed(category: String) {
        print("Category", category)
        DataProvider.shared.addCategory(header: category)
        delegate?.updateCategory()
    }
}
