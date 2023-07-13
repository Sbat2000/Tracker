
import UIKit

final class CreateCategoryViewController: UIViewController {
    
    var viewModel: CreateCategoryViewModel?
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("newCategory.title", comment: "")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var categoryHeaderTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .backgroundDay
        textField.textColor = .blackDay
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.placeholder = NSLocalizedString("newCategory.placeholder", comment: "")
        textField.layer.cornerRadius = 16
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypGray
        let title = NSLocalizedString("newCategory.readyButton.title", comment: "")
        button.setTitle(title, for: .normal)
        button.isUserInteractionEnabled = false
        button.setTitleColor(.whiteDay
                             , for: .normal)
        button.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        bind()
        setupKeyboard()
    }
    
    @objc
    private func createButtonPressed() {
        guard let category = categoryHeaderTextField.text else {return}
        viewModel?.createButtonPressed(category: category)
        self.dismiss(animated: true)
    }
    
    @objc
    private func textFieldDidChange() {
        viewModel?.didEnter(header: self.categoryHeaderTextField.text)
    }
    
    private func bind() {
        guard let viewModel else { return }
        viewModel.$isCreateButtonEnabled.bind {[weak self] newValue in
            self?.setCreateButton(enabled: newValue)
        }
    }
    
    private func setCreateButton(enabled: Bool) {
        createButton.isUserInteractionEnabled = enabled
        createButton.backgroundColor = enabled ? .blackDay : .ypGray
    }
    
    private func setupUI() {
        categoryHeaderTextField.delegate = self
        view.backgroundColor = .white
        view.addSubview(headerLabel)
        view.addSubview(categoryHeaderTextField)
        view.addSubview(createButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            categoryHeaderTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
            categoryHeaderTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryHeaderTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryHeaderTextField.heightAnchor.constraint(equalToConstant: 75),
            
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            createButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

extension CreateCategoryViewController: UITextFieldDelegate {

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func setupKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}
