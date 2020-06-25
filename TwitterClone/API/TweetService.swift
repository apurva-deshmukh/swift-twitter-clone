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
    
    func uploadTweet(caption: String, type: UploadTweetConfiguration, completion: @escaping (DatabaseCompletion)) {
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
            DB_REF_TWEET_REPLIES.child(tweet.tweetId).childByAutoId().updateChildValues(values, withCompletionBlock: { error, ref in
                guard let replyKey = ref.key else { return }
                DB_REF_USER_REPLIES.child(uid).updateChildValues([tweet.tweetId: replyKey], withCompletionBlock: completion)
            })
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
            
            self.fetchTweet(withTweetId: tweetId, completion: { tweet in
                tweets.append(tweet)
                completion(tweets)
            })
        })
    }
    
    func fetchReplies(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var replies = [Tweet]()
        
        DB_REF_USER_REPLIES.child(user.uid).observe(.childAdded, with: { snapshot in
            let tweetKey = snapshot.key
            guard let replyKey = snapshot.value as? String else { return }
            
            DB_REF_TWEET_REPLIES.child(tweetKey).child(replyKey).observeSingleEvent(of: .value, with: { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                UserService.shared.fetchUser(uid: uid, completion: { user in
                    let tweet = Tweet(user: user, tweetId: tweetKey, dictionary: dictionary)
                    replies.append(tweet)
                    completion(replies)
                })
            })
        })
    }
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        DB_REF_TWEET_REPLIES.child(tweet.tweetId).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetId = snapshot.key
            
            UserService.shared.fetchUser(uid: uid, completion: { user in
                let tweet = Tweet(user: user, tweetId: tweetId, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            })
        }
    }
    
    func likeTweet(tweet: Tweet, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        
        DB_REF_TWEETS.child(tweet.tweetId).child("likes").setValue(likes)
        
        if tweet.didLike {
            // unlike tweet
            DB_REF_USER_LIKES.child(uid).child(tweet.tweetId).removeValue(completionBlock: { error, ref in
                DB_REF_TWEET_LIKES.child(tweet.tweetId).removeValue(completionBlock: completion)
            })
        } else {
            // like tweet
            DB_REF_USER_LIKES.child(uid).updateChildValues([tweet.tweetId: 1], withCompletionBlock: { error, ref in
                DB_REF_TWEET_LIKES.child(tweet.tweetId).updateChildValues([uid: 1], withCompletionBlock: completion)
            })
        }
    }
    
    func fetchLikes(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        DB_REF_USER_LIKES.child(user.uid).observe(.childAdded, with: { snapshot in
            let tweetId = snapshot.key
            self.fetchTweet(withTweetId: tweetId, completion: { likedTweet in
                var tweet = likedTweet
                tweet.didLike = true
                tweets.append(tweet)
                completion(tweets)
            })
        })
    }
    
    func checkIfUserLikedTweet(_ tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        DB_REF_USER_LIKES.child(uid).child(tweet.tweetId).observeSingleEvent(of: .value, with: { snapshot in
            completion(snapshot.exists())
        })
    }
    
    func fetchTweet(withTweetId tweetId: String, completion: @escaping(Tweet) -> Void) {
        DB_REF_TWEETS.child(tweetId).observeSingleEvent(of: .value, with: { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            UserService.shared.fetchUser(uid: uid, completion: { user in
                let tweet = Tweet(user: user, tweetId: tweetId, dictionary: dictionary)
                completion(tweet)
            })
        })
    }
    
}
