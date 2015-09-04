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
        self.setupNavigator()
        self.loadSubviews()

        self.registerDataSourceClass(HomeDataSource.self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let orderQuery: AVQuery! = ABRSRepairOrder.query()
        orderQuery.whereKey("poster", equalTo: AVUser.currentUser())
        orderQuery.cachePolicy = AVCachePolicy.NetworkElseCache
        orderQuery.orderByDescending("createdAt")
        orderQuery.limit = 1000

        weak var weakSelf = self
        orderQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            weakSelf!.dataSource.setAllSectionObjects([results])
        }
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
        header?.subtitleLabel?.text = currentUser.department()
        header?.operationButton?.setTitle(currentUser.homeOperationButtonTitle, forState: .Normal)
        header?.operationButton?.addTarget(self, action: "publishRepairButtonTouchUpInsideHandler:", forControlEvents: .TouchUpInside)
    }
    
    private func setupNavigator() {
        self.title = "维修"
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
        if AVUser.currentUser().role() == .Normal && repairOrder != nil {
            let firstImage = repairOrder!.troubleImageFiles()?.first
            if firstImage != nil {
                firstImage!.getThumbnail(true, width: 180, height: 180, withBlock: { (image, error) -> Void in
                    cell.avatarImageView?.image = image
                })
            }
            cell.titleLabel!.text = repairOrder!.repairType().stringValue
            cell.contentLabel!.text = repairOrder!.troubleDescription()
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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