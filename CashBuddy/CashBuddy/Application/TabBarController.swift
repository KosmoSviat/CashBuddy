//
//  TabBarController.swift
//  CashBuddy
//
//  Created by Sviatoslav Samoilov on 4.09.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        view.tintColor = .white
    }
    
    // MARK: - Methods
    private func setupViewControllers() {
        viewControllers = [setupNavigationController(rootViewController: GeneralViewController(),
                                                     title: "general".localized.uppercased(),
                                      image: UIImage(systemName: "creditcard")),
            setupNavigationController(rootViewController: HistoryViewController(),
                                      title: "history".localized.uppercased(),
                                      image: UIImage(systemName: "list.bullet.rectangle"))]
    }
    
    private func setupNavigationController(rootViewController: UIViewController, title: String, image: UIImage?) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
}
