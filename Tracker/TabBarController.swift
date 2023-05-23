//
//  NavigationViewController.swift
//  Tracker
//
//  Created by Aleksandr Garipov on 23.05.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
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
        rootViewController.navigationItem.title = title
        return navController
    }
    
    private func setupVCs() {
        tabBar.layer.borderColor = Resources.Colors.ypGray.cgColor
        tabBar.layer.borderWidth = 1
        tabBar.layer.masksToBounds = true
        
        let trackersViewController = TrackersViewController()
        let statsViewController = StatsViewController()
        viewControllers = [
            createNavControllers(for: trackersViewController, title: "Трекеры", image: Resources.Images.TrackersTabBarIcon!),
            createNavControllers(for: statsViewController, title: "Статистика", image: Resources.Images.StatsTabBarIcon!)
        ]
    }
}
