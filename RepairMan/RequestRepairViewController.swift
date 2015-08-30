//
//  RequestRepairViewController.swift
//  RepairMan
//
//  Created by cherry on 15/8/23.
//  Copyright (c) 2015年 ABRS. All rights reserved.
//

import UIKit

class RequestRepairViewController: UIViewController {
    
    var tableView: UITableView?
    var header: ABRSProfileHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.loadSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension RequestRepairViewController {
    internal func loadSubviews() {
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        self.view.addSubview(tableView!)
        
        tableView!.mas_makeConstraints { (maker) -> Void in
            maker.edges.equalTo()(self.view)
        }
        
        header = ABRSProfileHeader(frame: CGRectMake(0, 0, self.view.bounds.width, 259))
        self.tableView?.tableHeaderView = header
        
        let currentUser: AVUser = AVUser.currentUser()
        header?.titleLabel?.text = currentUser.username
        header?.subtitleLabel?.text = currentUser["department"] as? String
        header?.operationButton?.setTitle("我要报修", forState: .Normal)
        header?.operationButton?.addTarget(self, action: "publishRepairButtonTouchUpInsideHandler:", forControlEvents: .TouchUpInside)
    }
}

extension RequestRepairViewController {
    internal func publishRepairButtonTouchUpInsideHandler(sender: AnyObject?) {
        let publishRepairVC = PublishRepairViewController()
        publishRepairVC.title = "我要报修"
        self.presentViewController(UINavigationController(rootViewController: publishRepairVC), animated: true, completion: nil)
    }
}
