//
//  NavigationViewController.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 23.05.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private var trackersViewController: TrackersViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = Resources.Colors.ypBlue
        setupVCs()
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
            rootViewController.navigationItem.leftBarButtonItem = button
            
            let datePicker = UIDatePicker()
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
        tabBar.layer.borderColor = Resources.Colors.ypGray.cgColor
        tabBar.layer.borderWidth = 1
        tabBar.layer.masksToBounds = true
        
        let trackersViewController = TrackersViewController()
        let statsViewController = StatsViewController()
        self.trackersViewController = trackersViewController
        viewControllers = [
            createNavControllers(for: trackersViewController, title: NSLocalizedString("tabBar.trackers.title", comment: ""), image: Resources.Images.TrackersTabBarIcon!),
            createNavControllers(for: statsViewController, title: NSLocalizedString("tabBar.stats.title", comment: ""), image: Resources.Images.StatsTabBarIcon!)
        ]
    }
    
    @objc
    private func leftButtonTapped() {
//        trackersViewController?.searchTextField.endEditing(true)
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
