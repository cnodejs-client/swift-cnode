//
//  Topic.swift
//  swift-cnode
//
//  Created by nswbmw on 16/3/27.
//  Copyright © 2016年 nswbmw. All rights reserved.
//

import SwiftyJSON

struct Topic {
    let id: String!
    let author_id: String!
    let tab: String!
    let content: String!
    let title: String!
    let last_reply_at: String!
    let good: Bool!
    let top: Bool!
    let reply_count: Int!
    let visit_count: Int!
    let create_at: String!
    let author: Author!
    let replies: [Comment]?
    let is_collect: Bool?
    
    init(_ topic: JSON) {
        self.id = topic["id"].string
        self.author_id = topic["author_id"].string
        self.tab = topic["tab"].string
        self.content = topic["content"].string
        self.title = topic["title"].string
        self.last_reply_at = topic["last_reply_at"].string
        self.good = topic["good"].bool
        self.top = topic["top"].bool
        self.reply_count = topic["reply_count"].int
        self.visit_count = topic["visit_count"].int
        self.create_at = topic["create_at"].string
        self.author = Author(topic["author"])
        
        var _replies = [Comment]()
        if topic["replies"] != nil {
            for comment in topic["replies"].arrayValue {
                _replies.append(Comment(comment))
            }
        }
        self.replies = _replies
        self.is_collect = topic["is_collect"].bool
    }
}