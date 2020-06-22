//
//  NotificationsController.swift
//  TwitterClone
//
//  Created by Apurva Deshmukh on 6/20/20.
//  Copyright © 2020 Apurva Deshmukh. All rights reserved.
//

import UIKit

class NotificationsController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureUI()
        
    }
    
    // MARK: - Helpers
 
    func configureUI() {
        
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
    }
    
}
