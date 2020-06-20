//
//  MainTabController.swift
//  TwitterClone
//
//  Created by Apurva Deshmukh on 6/20/20.
//  Copyright © 2020 Apurva Deshmukh. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {

    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureViewControllers()
        
    }

    // MARK: - Helpers
    
    /// Configures the view controllers
    func configureViewControllers() {
        
        let feed = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: FeedController())
        let explore = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: ExploreController())
        let notifications = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: NotificationsController())
        let conversations = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: ConversationsController())
        
        viewControllers = [feed, explore, notifications, conversations]
        
    }
    
    /// Creates a template navigation controller
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
        
    }
    
}
