//
//  HomeViewController.swift
//  
//
//  Created by cherry on 9/1/15.
//
//

import UIKit

class HomeViewController: YATableViewController {

    var header: ABRSProfileHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupNavigator()
        self.loadSubviews()

        self.registerDataSourceClass(HomeDataSource.self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        weak var weakSelf = self

        let orderQuery: AVQuery! = ABRSRepairOrder.query()
        orderQuery.cachePolicy = AVCachePolicy.NetworkElseCache
        orderQuery.limit = 1000

        if AVUser.currentUser().role() == .Normal {
            orderQuery.whereKey("poster", equalTo: AVUser.currentUser())
            orderQuery.orderByDescending("createdAt")
        } else {
            orderQuery.whereKey("serviceman", equalTo: AVUser.currentUser())
            orderQuery.whereKey("repairStatus", equalTo: ABRSRepairStatus.Repairing.rawValue)
            orderQuery.orderByDescending("updatedAt")
        }

        orderQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if results != nil {
                weakSelf!.dataSource.setAllSectionObjects([results])
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HomeViewController {
    private func loadSubviews() {
        header = ABRSProfileHeader(frame: CGRectMake(0, 0, self.view.bounds.width, 279))
        self.tableView?.tableHeaderView = header
        
        let currentUser: AVUser = AVUser.currentUser()
        header?.avatarImageView?.image =  UIImage(named: currentUser.role() == .Normal ? "NormalAvatar" : "RepairManAvatar")
        header?.titleLabel?.text = currentUser.username
        header?.subtitleLabel?.text = currentUser.department()
        header?.segmentLabel?.text = (AVUser.currentUser().role() == .Normal) ? "我的报修" : "我的维修"
        header?.operationButton?.setTitle(currentUser.homeOperationButtonTitle, forState: .Normal)
        header?.operationButton?.addTarget(self, action: "publishRepairButtonTouchUpInsideHandler:", forControlEvents: .TouchUpInside)
    }
    
    func setupNavigator() {
        self.title = "维修"
        
        weak var weakSelf = self
        let logoutBarButtonItems = UIBarButtonItem.barButtonItemsWithTitle("退出", actionBlock: { () -> Void in
            let alert = YAAlertView(title: "退出登录", message: nil)
            alert.setCancelButtonWithTitle("取消", block: nil)
            alert.addButtonWithTitle("退出", block: { () -> Void in
                AVUser.logOut()
                AppManager.sharedManager.rootNavigator.setViewControllers([LaunchViewController()],
                    animated: false)
                AppManager.sharedManager.rootNavigator.navigationBarHidden = true
            })
            alert.show()
        })
        self.navigationItem.rightBarButtonItems = logoutBarButtonItems as? [UIBarButtonItem]
    }
}

extension HomeViewController {
    internal func publishRepairButtonTouchUpInsideHandler(sender: AnyObject?) {
        if AVUser.currentUser().role() == .Normal {
            let publishRepairVC = PublishRepairViewController()
            publishRepairVC.title = "我要报修"
            publishRepairVC.delegate = self
            self.presentViewController(UINavigationController(rootViewController: publishRepairVC), animated: true, completion: nil)
        } else {
            let pickerController = RepairOrderPickerController()
            pickerController.title = "我要维修"
            self.presentViewController(UINavigationController(rootViewController: pickerController), animated: true, completion: nil)

        }
    }
}

extension HomeViewController: PublishRepairViewControllerDelegate {
    func publishRepairViewController(publishRepairVC: PublishRepairViewController,
        didFinishPublishWithInfo info: [String : AnyObject!]) {
            publishRepairVC.dismissViewControllerAnimated(true, completion: nil)
    }
}

class HomeDataSource: YATableDataSource {

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
        cell.selectionStyle = .None

        let repairOrder = self.objectAtIndexPath(indexPath) as? ABRSRepairOrder

        let firstImage = repairOrder!.troubleImageFiles()?.first
        if firstImage != nil {
            AVFile.getFileWithObjectId(firstImage?.objectId, withBlock: { (file, error) -> Void in
                file?.getThumbnail(true, width: 180, height: 180, withBlock: { (image, error) -> Void in
                    cell.avatarImageView?.image = image
                })
            })
        }

        if repairOrder != nil {
            if AVUser.currentUser().role() == .Normal {
                cell.titleLabel!.text = repairOrder!.repairType().stringValue
                cell.contentLabel!.text = repairOrder!.troubleDescription()
                cell.statusLabel!.text = repairOrder!.repairStatus().stringValue
                
                switch repairOrder!.repairStatus() {
                case .Waiting:
                    cell.statusLabel!.backgroundColor = UIColor(hex: 0x4A90E2)
                    
                case .Repairing:
                    cell.statusLabel!.backgroundColor = UIColor(hex: 0x31CCAA)
                    
                case .Finished:
                    cell.statusLabel!.backgroundColor = UIColor(hex: 0x666666)
                }
                
            } else {
                cell.titleLabel!.text = "报修人：\(repairOrder!.poster().username)"
                cell.subTitleLabel!.text = "地点：\(repairOrder!.address())"
                cell.contentLabel!.text = repairOrder!.troubleDescription()
                cell.statusLabel!.text = repairOrder!.troubleLevel().stringValue
                switch repairOrder!.troubleLevel() {
                case .NotUrgent:
                    cell.statusLabel!.backgroundColor = UIColor(hex: 0x31CCAA)
                    
                case .Urgent:
                    cell.statusLabel!.backgroundColor = UIColor(hex: 0xF5A623)
                    
                case .VeryUrgent:
                    cell.statusLabel!.backgroundColor = UIColor(hex: 0xFF2D0C)
                }
            }
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        
        if AVUser.currentUser().role() != .Normal {
            weak var repairOrder = self.objectAtIndexPath(indexPath) as? ABRSRepairOrder
            weak var weakSelf = self
            if repairOrder?.repairStatus() == .Repairing {
                let sheet = YAActionSheet(title: "操作")
                
                sheet.addButtonWithTitle("联系报修人", block: { () -> Void in
                    let phoneURL = NSURL(string: "tel://\(repairOrder?.poster().mobilePhoneNumber)")
                    UIApplication.sharedApplication().openURL(phoneURL!)
                })
                
                sheet.addButtonWithTitle("维修完成", block: { () -> Void in
                    weakSelf?.finishRepairOrder(repairOrder!)
                })
                
                sheet.setCancelButtonWithTitle("取消", block: nil)
                
                sheet.showInView(UIApplication.sharedApplication().keyboardWindow())
            }
        }
    }
    
    private func finishRepairOrder(repairOrder: ABRSRepairOrder) {
        let alert = YAAlertView(title: "维修完成了？", message: "这个东西已经修完了？")
        weak var weakSelf = self
        alert.setCancelButtonWithTitle("还没有", block: nil)
        alert.addButtonWithTitle("修完了", block: { () -> Void in
            repairOrder.setRepairStatus(.Finished)
            MBProgressHUD.showProgressHUDWithText("请求中...")
            repairOrder.saveInBackgroundWithBlock({ (success, error) -> Void in
                MBProgressHUD.hideHUDForView(UIApplication.sharedApplication().keyboardWindow(),
                    animated: false)
                if success == true {
                    weakSelf?.removeObject(repairOrder, atSection: 0)
                } else {
                    MBProgressHUD.showHUDWithText("请求失败", complete: nil)
                }
            })
        })
        alert.show()
    }
}

extension AVUser {
    private var homeOperationButtonTitle: String! {
        switch self.role() {
        case .Normal:
            return "我要报修"
            
        default:
            return "我要维修"
        }
    }
}
