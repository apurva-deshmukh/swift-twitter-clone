//
//  Tweet.swift
//  TwitterClone
//
//  Created by Apurva Deshmukh on 6/22/20.
//  Copyright © 2020 Apurva Deshmukh. All rights reserved.
//

import Foundation

struct Tweet {
    let caption: String
    let tweetId: String
    let uid: String
    let likes: Int
    var timestamp: Date!
    let retweetCount: Int
    
    
    init(tweetId: String, dictionary: [String: Any]) {
        self.tweetId = tweetId
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.uid = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["caption"] as? Int ?? 0
        self.retweetCount = dictionary["caption"] as? Int ?? 0
        
        if let timestamp = dictionary["caption"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
    
}
