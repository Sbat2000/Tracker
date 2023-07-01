
import UIKit

final class OnBoardingPagesController: UIPageViewController {
    private lazy var pages: [OnBoardViewController] = {
        let firstVC =
        OnBoardViewController(
            headerText: "Отслеживайте только то, что хотите",
            backGroundImage: Resources.Images.FirstOnBoardVCBackGround!)
        
        let secondVC =
        OnBoardViewController(
            headerText: "Даже если это не литры воды и йога",
            backGroundImage: Resources.Images.SecondOnBoardVCBackGround!)
        return [firstVC, secondVC]
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .blackDay
        pageControl.pageIndicatorTintColor = .gray
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 16
        button.setTitle("Вот это технологии!", for: .normal)
        button.backgroundColor = .blackDay
        button.setTitleColor(.whiteDay, for: .normal)
        button.addTarget(self, action: #selector(resumeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
                }
        view.addSubview(startButton)
        view.addSubview(pageControl)
        setupLayout()
    }
    
    @objc
    private func resumeButtonTapped() {
        let tabBarViewController = TabBarController()
        tabBarViewController.modalPresentationStyle = .fullScreen
        present(tabBarViewController, animated: true)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -168),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            startButton.heightAnchor.constraint(equalToConstant: 60),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

extension OnBoardingPagesController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController as! OnBoardViewController) else { return nil}
        
        var previousIndex = viewControllerIndex - 1
        
        if previousIndex < 0 {
            previousIndex = pages.count - 1
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController as! OnBoardViewController) else { return nil}
        
        var nextIndex = viewControllerIndex + 1
        
        if nextIndex > pages.count - 1 {
            nextIndex = 0
        }
        
        return pages[nextIndex]
    }
}

extension OnBoardingPagesController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController as! OnBoardViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
