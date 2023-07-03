

import Foundation

final class CreateCategoryViewModel {
    
    @Observable
    private(set) var isCreateButtonEnabled: Bool = false
    
    weak var delegate: CreateCategoryViewModelDelegate?
    
    func didEnter(header: String?) {
        guard let header else { return }
        isCreateButtonEnabled = header != ""
    }
    
    func createButtonPressed(category: String) {
        DataProvider.shared.addCategory(header: category)
        delegate?.updateCategory()
    }
}
