//
//  UserService.swift
//  TwitterClone
//
//  Created by Apurva Deshmukh on 6/22/20.
//  Copyright © 2020 Apurva Deshmukh. All rights reserved.
//

import Firebase

struct UserService {
    
    static let shared = UserService()
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        DB_REF_USERS.child(uid).observeSingleEvent(of: .value, with: { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        })
    }
    
}
