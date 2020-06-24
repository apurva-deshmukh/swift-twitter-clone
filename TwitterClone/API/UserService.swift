//
//  UserService.swift
//  TwitterClone
//
//  Created by Apurva Deshmukh on 6/22/20.
//  Copyright © 2020 Apurva Deshmukh. All rights reserved.
//

import Firebase

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    
    static let shared = UserService()
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        DB_REF_USERS.child(uid).observeSingleEvent(of: .value, with: { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        })
    }
    
    func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        DB_REF_USERS.observe(.childAdded, with: { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        })
    }
    
    func followUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DB_REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1], withCompletionBlock: { error, ref in
            DB_REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        })
    }
    
    func unfollowUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DB_REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue(completionBlock: { error, ref in
            DB_REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        })
    }
    
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DB_REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value, with: { snapshot in
            print("DEBUG: User is followed is \(snapshot.exists())")
            completion(snapshot.exists())
        })
    }
    
    func fetchUserStats(uid: String, completion: @escaping(UserRelationStats) -> Void) {
        DB_REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value, with: { snapshot in
            let followers = snapshot.children.allObjects.count

            DB_REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value, with: { snapshot in
                let following = snapshot.children.allObjects.count

                let stats = UserRelationStats(followers: followers, following: following)
                completion(stats)
            })
        })
    }
}
