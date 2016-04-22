//
//  User.swift
//  swift-cnode
//
//  Created by nswbmw on 16/3/27.
//  Copyright © 2016年 nswbmw. All rights reserved.
//

import Foundation

class Author : PPJSONSerialization {
    var loginname: String?
    var avatar_url: String? {
        didSet {
            // 如果用户的是用的gravatar头像，那么通过api获取到的avatar_url会缺少开头的"https:"，导致头像无法正确加载
            if avatar_url!.hasPrefix("//") {
                avatar_url = "https:" + avatar_url!
            }
        }
    }
    var githubUsername: String?
    var create_at: NSDate?
    var recent_topics: [Topic] = []
    var recent_replies: [Topic] = []
}