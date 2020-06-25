//
//  NotificationViewModel.swift
//  TwitterClone
//
//  Created by Apurva Deshmukh on 6/25/20.
//  Copyright © 2020 Apurva Deshmukh. All rights reserved.
//

import UIKit

struct NotificationViewModel {
    
    private let notification: Notification
    private let type: NotificationType
    private let user: User
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: notification.timestamp, to: now) ?? "0s"
    }
    
    var notificationMessage: String {
        switch type {
        case .follow: return " started following you"
        case .like: return " liked one of your tweets"
        case .reply: return " replied to your tweets"
        case .retweet: return " retweeted your tweet"
        case .mention: return " mentioned you in a tweet"
        }
    }
    
    var notificationText: NSAttributedString? {
        guard let timestamp = timestampString else { return nil }
        
        let attributedString = NSMutableAttributedString(string: user.username,
                                                         attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        attributedString.append(NSAttributedString(string: notificationMessage,
                                                   attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        attributedString.append(NSAttributedString(string: " \(timestamp)",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                         NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        return attributedString
    }
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    init(notification: Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
}
