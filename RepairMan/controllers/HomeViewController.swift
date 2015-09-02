//
//  HomeViewController.swift
//  
//
//  Created by liuyan on 9/1/15.
//
//

import UIKit

class HomeViewController: YATableViewController {

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

extension HomeViewController {
    private func loadSubviews() {
        header = ABRSProfileHeader(frame: CGRectMake(0, 0, self.view.bounds.width, 259))
        self.tableView?.tableHeaderView = header
        
        let currentUser: AVUser = AVUser.currentUser()
        header?.titleLabel?.text = currentUser.username
        header?.subtitleLabel?.text = currentUser.department
        header?.operationButton?.setTitle(currentUser.homeOperationButtonTitle, forState: .Normal)
        header?.operationButton?.addTarget(self, action: "publishRepairButtonTouchUpInsideHandler:", forControlEvents: .TouchUpInside)
    }
    
    private func setupNavigator() {
        self.title = "维修"
    }
}

extension HomeViewController {
    internal func publishRepairButtonTouchUpInsideHandler(sender: AnyObject?) {
        if AVUser.currentUser().role == .Normal {
            let publishRepairVC = PublishRepairViewController()
            publishRepairVC.title = "我要报修"
            self.presentViewController(UINavigationController(rootViewController: publishRepairVC), animated: true, completion: nil)
        } else {
            
        }
    }
}

extension AVUser {
    private var homeOperationButtonTitle: String! {
        switch self.role {
        case .Normal:
            return "我要报修"
            
        default:
            return "我要维修"
        }
    }
}