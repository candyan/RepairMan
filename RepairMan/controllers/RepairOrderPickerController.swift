//
//  RepairOrderPickerController.swift
//  RepairMan
//
//  Created by liuyan on 15/9/4.
//  Copyright (c) 2015年 ABRS. All rights reserved.
//

import UIKit

class RepairOrderPickerController: YATableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

     // Do any additional setup after loading the view.
        self.setupNavigator()
        self.registerDataSourceClass(RepairOrderPikerDataSource.self)
        self.dataSource.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        weak var weakSelf = self

        let orderQuery: AVQuery! = ABRSRepairOrder.query()
        orderQuery.cachePolicy = AVCachePolicy.NetworkElseCache
        orderQuery.limit = 1000

        orderQuery.whereKey("repairStatus", equalTo: ABRSRepairStatus.Waiting.rawValue)
        orderQuery.orderByDescending("createdAt")
        if AVUser.currentUser().role() == .GeneralMaintenance {
            orderQuery.whereKey("repairType", equalTo: ABRSRepairType.General.rawValue)
        } else {
            orderQuery.whereKey("repairType",
                containedIn: [ABRSRepairType.Software.rawValue, ABRSRepairType.Hardware.rawValue])
        }

        orderQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            weakSelf!.dataSource.setAllSectionObjects([results])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupNavigator() {
        self.title = "维修列表"

        weak var weakSelf = self
        let closeBarButtonItems = UIBarButtonItem.barButtonItemsWithImage(UIImage(named: "NaviClose"),
            actionBlock: { () -> Void in
                weakSelf?.dismissViewControllerAnimated(true, completion: nil)
        })
        self.navigationItem.leftBarButtonItems = closeBarButtonItems as? [UIBarButtonItem]
    }

}

extension RepairOrderPickerController: YATableDataSourceDelegate {
    func tableDataSource(dataSource: YATableDataSource!, didSelectObject object: AnyObject!, atIndexPath indexPath: NSIndexPath!) {
        weak var weakSelf = self
        weak var selectRepairOrder = object as? ABRSRepairOrder
        
        selectRepairOrder!.setServiceman(AVUser.currentUser())
        selectRepairOrder!.setRepairStatus(.Repairing)
        
        let alert = YAAlertView(title: "是否要维修这个", message: nil)
        
        alert.setCancelButtonWithTitle("点错了", block: nil)
        alert.addButtonWithTitle("是的", block: { () -> Void in
            MBProgressHUD.showProgressHUDWithText("请求中...")
            selectRepairOrder!.saveInBackgroundWithBlock({ (success, error) -> Void in
                if success == true {
                    MBProgressHUD.showHUDWithText("请求成功", complete: { () -> Void in
                        weakSelf?.dismissViewControllerAnimated(true, completion: nil)
                    })
                } else {
                    MBProgressHUD.showHUDWithText("请求失败", complete: nil)
                }
            })
        })
        
        alert.show()
    }
}

class RepairOrderPikerDataSource: YATableDataSource {

    override init() {
        super.init()
    }

    override init!(tableView: UITableView!) {
        super.init(tableView: tableView)

        tableView.registerReuseCellClass(RepairOrderCell.self)
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let repairOrderForRow = self.objectAtIndexPath(indexPath) as? ABRSRepairOrder
        let repairOrderDescription = repairOrderForRow?.troubleDescription()
        return RepairOrderCell.heightForContent(repairOrderDescription!,
            limitedSize: CGSize(width: tableView.bounds.width, height: CGFloat(FLT_MAX)))
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithClass(RepairOrderCell.self) as! RepairOrderCell

        let repairOrder = self.objectAtIndexPath(indexPath) as? ABRSRepairOrder

        let firstImage = repairOrder!.troubleImageFiles()?.first
        if firstImage != nil {
            firstImage!.getThumbnail(true, width: 180, height: 180, withBlock: { (image, error) -> Void in
                cell.avatarImageView?.image = image
            })
        }

        if repairOrder != nil {
            if AVUser.currentUser().role() == .Normal {
                cell.titleLabel!.text = repairOrder!.repairType().stringValue
                cell.contentLabel!.text = repairOrder!.troubleDescription()
            } else {
                cell.titleLabel!.text = repairOrder!.poster().username
                cell.contentLabel!.text = repairOrder!.troubleDescription()
            }
        }

        return cell
    }
}

