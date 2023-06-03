

import UIKit

final class LaunchScreenViewController: UIViewController {
    
    private lazy var logoImageView: UIImageView = {
        let logoImage = UIImageView()
        logoImage.image = Resources.Images.logoImage
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        return logoImage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLaunchScreen()
        sleep(5)
        
    }
    
    private func setupLaunchScreen() {
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        view.backgroundColor = Resources.Colors.ypBlue
        view.addSubview(logoImageView)
        
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
