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

let STORAGE_REF = Storage.storage().reference()
let STORAGE_REF_PROFILE_IMAGE = STORAGE_REF.child("profile_images")
