//
//  User.swift
//  swift-cnode
//
//  Created by nswbmw on 16/3/27.
//  Copyright © 2016年 nswbmw. All rights reserved.
//

import SwiftyJSON

struct Author {
    let loginname: String!
    let avatar_url: String!

    init(_ author: JSON) {
        self.loginname = author["loginname"].string
        self.avatar_url = author["avatar_url"].string
    }
}