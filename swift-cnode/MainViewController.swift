//
//  MainViewController.swift
//  swift-cnode
//
//  Created by nswbmw on 16/3/27.
//  Copyright © 2016年 nswbmw. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import PageMenu
import Alamofire

class MainViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - UI Setup
        
        self.title = "CNode社区"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // MARK: - Scroll menu setup
        
        // Initialize view controllers to display and place in array
        var controllerArray: [UIViewController] = []
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        for tab in Tab.allTabs {
            let controller = mainStoryboard.instantiateViewControllerWithIdentifier("topicListsTableView")
            controller.title = tab
            controllerArray.append(controller)
        }
    
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)),
            .SelectionIndicatorColor(UIColor(red: 0.0, green: 214.0/255.0, blue: 0.0, alpha: 1.0)),
            .SelectionIndicatorHeight(2),
            .BottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .MenuItemFont(UIFont(name: "HelveticaNeue", size: 13.0)!),
            .MenuHeight(30.0),
            .MenuItemWidth(50.0),
            .CenterMenuItems(true)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.didMoveToParentViewController(self)
    }
    
//    override func didFinishLaunchingWithOptions() {
//        
//    }
}
