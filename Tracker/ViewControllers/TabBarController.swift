//
//  NavigationViewController.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 23.05.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private var trackersViewController: TrackersViewController?
    private lazy var analyticsService = AnalyticsService()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Resources.Colors.tabBarBorderColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = Resources.Colors.ypBlue
        setupVCs()
        setupSeparatorView()
    }
    
    private func createNavControllers(for rootViewController: UIViewController,
                                      title: String,
                                      image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        
        if rootViewController is TrackersViewController {
            let button = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(leftButtonTapped))
            button.tintColor = Resources.Colors.ypBlack
            rootViewController.navigationItem.leftBarButtonItem = button
            
            let datePicker = UIDatePicker()
            datePicker.backgroundColor = Resources.Colors.datePickerBackgroundColor
            datePicker.preferredDatePickerStyle = .compact
            datePicker.datePickerMode = .date
            let datePickerItem = UIBarButtonItem(customView: datePicker)
            rootViewController.navigationItem.rightBarButtonItem = datePickerItem
            self.trackersViewController?.datePicker = datePicker
        }
        rootViewController.navigationItem.title = title
        return navController
    }
    
    private func setupVCs() {
        let trackersViewController = TrackersViewController()
        let statsViewController = StatsViewController()
        self.trackersViewController = trackersViewController
        viewControllers = [
            createNavControllers(for: trackersViewController, title: NSLocalizedString("tabBar.trackers.title", comment: ""), image: Resources.Images.TrackersTabBarIcon!),
            createNavControllers(for: statsViewController, title: NSLocalizedString("tabBar.stats.title", comment: ""), image: Resources.Images.StatsTabBarIcon!)
        ]
        view.addSubview(separatorView)
    }
    
    private func setupSeparatorView() {
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    @objc
    private func leftButtonTapped() {
        analyticsService.report(event: .click, screen: .main, item: .addTrack)
        trackersViewController?.presentSelectTypeVC()
    }
    
    func showOnlyTrackersViewController() {
         if let trackersViewController = self.trackersViewController {
             let newViewControllers = [trackersViewController]
             self.viewControllers = newViewControllers
             self.selectedIndex = 0
         }
     }
}
