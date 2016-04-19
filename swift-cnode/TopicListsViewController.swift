//
//  TopicViewController.swift
//  swift-cnode
//
//  Created by nswbmw on 16/3/28.
//  Copyright © 2016年 nswbmw. All rights reserved.
//

import UIKit

var topics = [String: [Topic]]()
var pages = [String: Int]()

class TopicListsViewController: UITableViewController {
    var tab = ""
    var refreshing = false
    var loading = false
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.tab = Tab.getTabByName(self.title)
        // 下拉刷新
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(TopicListsViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl!)
        
        if topics[self.tab]?.count == nil {
            refresh()
        }
    }
   
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics[self.tab]?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("topicCell")! as UITableViewCell
        let topic: Topic = topics[self.tab]![indexPath.row]
        
        let avatar = cell.viewWithTag(1) as! UIImageView
        let title = cell.viewWithTag(2) as! UILabel
        let subtitle = cell.viewWithTag(3) as! UILabel
        
        let isTop = Bool(topic.top)
        let tab = isTop ? "置顶" : Tab(tab: topic.tab).rawValue
        
        avatar.kf_setImageWithURL(NSURL(string: topic.author!.avatar_url!)!)
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = 5
        title.text = topic.title
        subtitle.text = tab + " • " + topic.author!.loginname! + " • " + Util.fromNow(topic.last_reply_at!)
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //上拉加载
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maximumOffset - currentOffset) <= 70 {
            // 防止多次请求
            if self.loading {
                return
            }
            self.loading = true
            var page = pages[self.tab]
            if page == nil {
                page = 0
            }
            API.getTopicList(page! + 1, tab: self.tab, error: { err in
                showToast(err)
                self.loading = false
            }, success: { _topics in
                if topics[self.tab] == nil {
                    topics[self.tab] = _topics
                } else {
                    topics[self.tab] = topics[self.tab]! + _topics
                }
                self.loading = false
                pages[self.tab] = page! + 1
                self.tableView.reloadData()
            })
        }
    }
    
    // 跳转
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let topicViewController = segue.destinationViewController as! TopicViewController
        let indexPath = tableView.indexPathForSelectedRow!
        topicViewController.topic = topics[self.tab]![indexPath.row]
    }
    
    // 下拉刷新
    func refresh() {
        // 防止多次请求
        if self.refreshing {
            return
        }
        self.refreshing = true
        API.getTopicList(tab: self.tab, error: { err in
            showToast(err)
            self.refreshControl!.endRefreshing()
            self.refreshing = false
        }, success: { _topics in
            topics[self.tab] = _topics
            self.refreshControl!.endRefreshing()
            self.refreshing = false
            pages[self.tab] = 1
            self.tableView.reloadData()
        })
    }
}