//
//  PublishRepairViewController.swift
//  RepairMan
//
//  Created by cherry on 15/8/30.
//  Copyright (c) 2015年 ABRS. All rights reserved.
//

import UIKit

class PublishRepairViewController: YATableViewController {
    
    weak var sendButton: UIButton?
    
    var publishRepairDS: PublishRepairDataSource {
        return self.dataSource as! PublishRepairDataSource
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupNavigator()
        
        self.loadSubviews()
        self.registerDataSourceClass(PublishRepairDataSource.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendButtonTouchUpInsideHandler(sender: UIButton) {
        
    }

}

// subviews
extension PublishRepairViewController {
    private func loadSubviews() {
        sendButton = UIButton(frame: CGRectZero)
        self.view.addSubview(sendButton!)
        
        sendButton!.mas_makeConstraints { (maker) -> Void in
            maker.bottom.equalTo()(self.view).offset()(-20)
            maker.height.mas_equalTo()(44)
            maker.leading.equalTo()(self.view).offset()(50)
            maker.trailing.equalTo()(self.view).offset()(-50)
        }
        
        sendButton?.backgroundColor = UIColor(hex: 0x4A90E0)
        sendButton?.layer.cornerRadius = 22
        sendButton?.layer.masksToBounds = true
        sendButton?.titleLabel?.font = UIFont(name: "Helvetica", size: 16)
        sendButton?.setTitle("报修", forState: .Normal)
        sendButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        sendButton?.addTarget(self, action: "sendButtonTouchUpInsideHandler:", forControlEvents: .TouchUpInside)
    }
    
    private func setupNavigator() {
        self.title = "我要报修"
        
        weak var weakSelf = self
        let closeBarButtonItems = UIBarButtonItem.barButtonItemsWithImage(UIImage(named: "NaviClose"),
            actionBlock: { () -> Void in
                weakSelf?.dismissViewControllerAnimated(true, completion: nil)
        })
        self.navigationItem.leftBarButtonItems = closeBarButtonItems as? [UIBarButtonItem]
    }
}

class PublishRepairDataSource: YATableDataSource {
    
    var repairOrder: ABRSRepairOrder!
    
    override init!(tableView: UITableView!) {
        repairOrder = ABRSRepairOrder()
        repairOrder.poster = AVUser.currentUser()
        repairOrder.repairType = .General
        repairOrder.troubleLevel = .NotUrgent
        
        super.init(tableView: tableView)
        
        tableView.registerReuseCellClass(RepairEditEntryCell.self)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithClass(RepairEditEntryCell.self) as! RepairEditEntryCell
        
        switch indexPath.row {
        case 0:
            cell.titleLabel?.text = "故障类型"
            cell.contentLabel?.text = repairOrder.repairType.stringValue

        case 1:
            cell.titleLabel?.text = "文字描述"
            cell.contentLabel?.text = repairOrder.troubleDescription
            
        case 2:
            cell.titleLabel?.text = "紧急程度"
            cell.contentLabel?.text = repairOrder.troubleLevel.stringValue
            
        case 3:
            cell.titleLabel?.text = "地       点"
            cell.contentLabel?.text = repairOrder.address
            
        default:
            cell.titleLabel?.text = ""
            cell.contentLabel?.text = ""
            
        }
        
        return cell
    }
}