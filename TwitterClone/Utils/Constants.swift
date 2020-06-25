//
//  Constants.swift
//  TwitterClone
//
//  Created by Apurva Deshmukh on 6/22/20.
//  Copyright © 2020 Apurva Deshmukh. All rights reserved.
//

import Firebase

let DB_REF = Database.database().reference()
let DB_REF_USERS = DB_REF.child("users")
let DB_REF_TWEETS = DB_REF.child("tweets")
let DB_REF_USER_TWEETS = DB_REF.child("user-tweets")
let DB_REF_USER_FOLLOWERS = DB_REF.child("user-followers")
let DB_REF_USER_FOLLOWING = DB_REF.child("user-following")
let DB_REF_TWEET_REPLIES = DB_REF.child("tweet-replies")
let DB_REF_USER_LIKES = DB_REF.child("user-likes")
let DB_REF_TWEET_LIKES = DB_REF.child("tweet-likes")
let DB_REF_NOTIFICATIONS = DB_REF.child("notifications")
let DB_REF_USER_REPLIES = DB_REF.child("user-replies")

let STORAGE_REF = Storage.storage().reference()
let STORAGE_REF_PROFILE_IMAGE = STORAGE_REF.child("profile_images")


