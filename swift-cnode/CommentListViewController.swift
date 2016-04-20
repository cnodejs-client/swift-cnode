//
//  CommentListViewController.swift
//  swift-cnode
//
//  Created by nswbmw on 16/4/6.
//  Copyright © 2016年 nswbmw. All rights reserved.
//

import UIKit

class CommentListViewController: UITableViewController, UIWebViewDelegate {
    
    var topicId: String!
    var topic: Topic? {
        didSet {
            webContentHeights.removeAll()

            for _ in (topic?.replies)! {
                webContentHeights.append(0.0)
            }
        }
    }
    var refreshing = false

    var webViewDelegate: ContentWebViewDelegate!
    var webContentHeights: [CGFloat] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        webViewDelegate = ContentWebViewDelegate(self)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150

        // 下拉刷新
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(CommentListViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl!)
        
        if topic == nil {
            refresh()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topic?.replies.count ?? 0
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return webContentHeights[indexPath.row] + 60
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("commentCell")! as! CommentCell
        
        if topic?.replies == nil || (topic?.replies.isEmpty)! {
            return cell
        }

        let comments = Array(topic!.replies.reverse())
        let comment = comments[indexPath.row]

        cell.avatarImageView.kf_setImageWithURL(NSURL(string: comment.author!.avatar_url!)!)
        cell.avatarImageView.layer.masksToBounds = true
        cell.avatarImageView.layer.cornerRadius = 5

        cell.authorLabel.text = comment.author!.loginname
        cell.timeLabel.text = Util.fromNow(comment.create_at!)

        cell.contentWebView.delegate = self
        cell.contentWebView.tag = indexPath.row
        cell.contentWebView.backgroundColor = UIColor.clearColor()
        cell.contentWebView.opaque = false
        cell.contentWebView.scrollView.showsVerticalScrollIndicator = false
        cell.contentWebView.scrollView.scrollEnabled = false
        cell.contentWebView.scrollView.bounces = false

        cell.contentWebView.loadHTMLString(wrapContent(comment.content!), baseURL: API.BASE_URL)
        cell.contentWebView.scrollView.delegate = self

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

    func webViewDidFinishLoad(webView: UIWebView) {
        webView.delegate = webViewDelegate
        if webContentHeights[webView.tag] != 0.0 {
            return;
        }

        let heightStr = webView.stringByEvaluatingJavaScriptFromString("document.body.scrollHeight")
        let height = CGFloat(Double(heightStr!)!)
        webContentHeights[webView.tag] = height
        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: webView.tag, inSection: 0)], withRowAnimation: .Automatic);
    }
}
