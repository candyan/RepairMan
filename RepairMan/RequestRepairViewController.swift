//
//  RequestRepairViewController.swift
//  RepairMan
//
//  Created by cherry on 15/8/23.
//  Copyright (c) 2015年 ABRS. All rights reserved.
//

import UIKit

class RequestRepairViewController: UIViewController {

    var currentName: String!
    var currentDepartment: String!
    var currentPhonenumber: String!
    
    var tableView: UITableView?
    
    convenience init(name: String!, department: String!, phoneNumber: String!) {
        self.init()
        currentName = name
        currentDepartment = department
        currentPhonenumber = phoneNumber
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
    }
}