//
//  TweetService.swift
//  TwitterClone
//
//  Created by Apurva Deshmukh on 6/22/20.
//  Copyright © 2020 Apurva Deshmukh. All rights reserved.
//

import Firebase

struct TweetService {
    
    static let shared = TweetService()
    
    func uploadTweet(caption: String, type: UploadTweetConfiguration, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0,
                      "caption": caption] as [String: Any]
        
        switch type {
        case .tweet:
             DB_REF_TWEETS.childByAutoId().updateChildValues(values, withCompletionBlock: { error, ref in
                guard let tweetId = ref.key else { return }
                DB_REF_USER_TWEETS.child(uid).updateChildValues([tweetId: 1], withCompletionBlock: completion)
            })
            
        case .reply(let tweet):
            DB_REF_TWEET_REPLIES.child(tweet.tweetId).childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        }
    }
    
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        DB_REF_TWEETS.observe(.childAdded, with: { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetId = snapshot.key
            
            UserService.shared.fetchUser(uid: uid, completion: { user in
                let tweet = Tweet(user: user, tweetId: tweetId, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            })
        })
    }
    
    func fetchTweets(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        DB_REF_USER_TWEETS.child(user.uid).observe(.childAdded, with: { snapshot in
            let tweetId = snapshot.key
            DB_REF_TWEETS.child(tweetId).observeSingleEvent(of: .value, with: { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                UserService.shared.fetchUser(uid: uid, completion: { user in
                    let tweet = Tweet(user: user, tweetId: tweetId, dictionary: dictionary)
                    tweets.append(tweet)
                    completion(tweets)
                })
            })
        })
    }
    
}
