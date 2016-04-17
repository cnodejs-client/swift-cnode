//
//  CommentListViewController.swift
//  swift-cnode
//
//  Created by nswbmw on 16/4/6.
//  Copyright © 2016年 nswbmw. All rights reserved.
//

import UIKit

class CommentListViewController: UITableViewController {
    
    var topicId: String!
    var topic: Topic?
    var refreshing = false

    var webViewDelegate: ContentWebViewDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        webViewDelegate = ContentWebViewDelegate(self)

        // 下拉刷新
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(CommentListViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl!)
        
        if topic == nil {
            refresh()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topic?.replies?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("commentCell")! as UITableViewCell
        
        if topic?.replies == nil || (topic?.replies!.isEmpty)! {
            return cell
        }

        let avatar = cell.viewWithTag(1) as! UIImageView
        let title = cell.viewWithTag(2) as! UILabel
        let subtitle = cell.viewWithTag(3) as! UILabel
        let commentWebView = cell.viewWithTag(4) as! UIWebView

        let comments = Array(topic!.replies!.reverse())
        let comment = comments[indexPath.row]
        
        avatar.kf_setImageWithURL(NSURL(string: comment.author.avatar_url)!)
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = 5
        title.text = comment.author.loginname
        subtitle.text = Util.fromNow(comment.create_at)
        
        commentWebView.delegate = webViewDelegate
        commentWebView.backgroundColor = UIColor.clearColor()
        commentWebView.opaque = false
        commentWebView.scrollView.showsVerticalScrollIndicator = false
        commentWebView.scrollView.bounces = false
        commentWebView.loadHTMLString(wrapContent(comment.content), baseURL: API.BASE_URL)
        commentWebView.scrollView.delegate = self

        return cell
    }

//    func webViewDidFinishLoad(commentWebView: UIWebView) {
//        let x = Double(commentWebView.frame.origin.x)
//        let y = Double(commentWebView.frame.origin.y)
//        let width: Double = Double(commentWebView.stringByEvaluatingJavaScriptFromString("document.body.offsetWidth")!)!
//        let height: Double = Double(commentWebView.stringByEvaluatingJavaScriptFromString("document.body.offsetHeight")!)!
////        print(x, y, width, height, commentWebView.frame.origin)
//        
//        
//        commentWebView.frame = CGRect(x: x, y: y, width: width, height: height)
//        commentWebView.userInteractionEnabled = false
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 下拉刷新
    func refresh() {
        // 防止多次请求
        if self.refreshing {
            return
        }
        self.refreshing = true
        API.getTopicDetail(self.topicId, mdrender: "true", error: { err in
            showToast(err)
            self.refreshControl!.endRefreshing()
            self.refreshing = false
        }, success: { _topic in
            self.topic = _topic
            self.refreshControl!.endRefreshing()
            self.refreshing = false
            self.tableView.reloadData()
        })
    }
    
    func wrapContent(content: String) -> String {
        return "<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"initial-scale=1, user-scalable=no, width=device-width\" /><style>html, body, div, p, img {width: 100%;word-break: break-all;word-wrap: break-word;} html, body { margin: 0; }</style></head><body>" + content + "</body></html>"
    }
}
