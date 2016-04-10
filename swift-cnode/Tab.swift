//
//  Tab.swift
//  swift-cnode
//
//  Created by nswbmw on 16/3/27.
//  Copyright © 2016年 nswbmw. All rights reserved.
//

enum Tab: String {
    case all = "全部"
    case ask = "问答"
    case share = "分享"
    case good = "精华"
    case job = "招聘"
    
    init(tab: String?) {
        if tab == nil {
            self = .share
            return
        }
        switch tab! {
        case "ask": self = .ask
        case "share": self = .share
        case "good": self = .good
        case "job": self = .job
        default: self = .share
        }
    }
    static let allTabs = ["全部" ,"问答", "分享", "精华", "招聘"]
    static func getTabByName(name: String?) -> String {
        if name == nil {
            return ""
        }
        switch name! {
        case "问答": return "ask"
        case "分享": return "share"
        case "精华": return "good"
        case "招聘": return "job"
        default: return ""
        }
    }
}