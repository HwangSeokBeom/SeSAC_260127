//
//  MainTabBarController.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/26/26.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabs()
        customizeTabBar()
    }

    private func setupTabs() {
        let topicVC = DIContainer.shared.makeTopicViewController()

        let calendarVC = UIViewController()
        calendarVC.view.backgroundColor = .systemBackground
        calendarVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "calendar"),
            selectedImage: UIImage(systemName: "calendar.circle.fill")
        )

        let searchVC = UIViewController()
        searchVC.view.backgroundColor = .systemBackground
        searchVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )

        let favoriteVC = UIViewController()
        favoriteVC.view.backgroundColor = .systemBackground
        favoriteVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )

        viewControllers = [
            UINavigationController(rootViewController: topicVC),
            UINavigationController(rootViewController: calendarVC),
            UINavigationController(rootViewController: searchVC),
            UINavigationController(rootViewController: favoriteVC)
        ]
    }

    private func customizeTabBar() {
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
    }
}
