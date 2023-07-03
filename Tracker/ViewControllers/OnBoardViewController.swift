import UIKit

class OnBoardViewController: UIViewController {
    var headerText: String
    var backGroundImage: UIImage?
    
    private lazy var backGroundImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = headerText
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .blackDay
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(headerText: String, backGroundImage: UIImage) {
        self.headerText = headerText
        self.backGroundImage = backGroundImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        backGroundImageView.image = backGroundImage
        view.addSubview(backGroundImageView)
        backGroundImageView.addSubview(headerLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            backGroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backGroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backGroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backGroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerLabel.topAnchor.constraint(equalTo: backGroundImageView.topAnchor, constant: 452),
            headerLabel.leadingAnchor.constraint(equalTo: backGroundImageView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: backGroundImageView.trailingAnchor, constant: -16)
        ])
    }
}
