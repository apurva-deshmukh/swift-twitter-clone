//
//  ActionSheetLauncher.swift
//  TwitterClone
//
//  Created by Apurva Deshmukh on 6/24/20.
//  Copyright © 2020 Apurva Deshmukh. All rights reserved.
//

import Foundation

class ActionSheetLauncher: NSObject {
    
    // MARK: - Properties
    
    private let user: User
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init()
    }
    
    // MARK: - Helpers
    
    func show() {
        print("DEBUG: Show action sheet for \(user.username)")
    }
}
