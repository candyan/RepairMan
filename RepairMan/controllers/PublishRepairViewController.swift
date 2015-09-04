//
//  PublishRepairViewController.swift
//  RepairMan
//
//  Created by cherry on 15/8/30.
//  Copyright (c) 2015年 ABRS. All rights reserved.
//

import UIKit

@objc protocol PublishRepairViewControllerDelegate:NSObjectProtocol {
    optional func publishRepairViewController(publishRepairVC: PublishRepairViewController, didFinishPublishWithInfo info: [String: AnyObject!])
}


class PublishRepairViewController: YATableViewController {

    weak var delegate: PublishRepairViewControllerDelegate?
    var sendButton: UIButton?
    
    var publishRepairDS: PublishRepairDataSource {
        return self.dataSource as! PublishRepairDataSource
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = .None
        
        self.setupNavigator()
        self.registerDataSourceClass(PublishRepairDataSource.self)
        self.loadSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendButtonTouchUpInsideHandler(sender: UIButton) {
        let photos = self.publishRepairDS.photosEditorView.photos
        if photos.count != 0 {
            self.publishRepairDS.repairOrder.setTroubleImages(photos as? [UIImage])
        }
        weak var weakSelf = self
        MBProgressHUD.showProgressHUDWithText("正在保修...")
        self.publishRepairDS.repairOrder.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success == true {
                MBProgressHUD.hideHUDForView(UIApplication.sharedApplication().keyboardWindow(),
                    animated: false)
                weakSelf?.delegate?.publishRepairViewController!(weakSelf!,
                    didFinishPublishWithInfo: ["order": weakSelf?.publishRepairDS.repairOrder])
            }
        })
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
    var photosEditorView: ItemPhotosEditorView!

    override init() {
        super.init()
    }

    override init(tableView: UITableView!) {
        super.init(tableView: tableView)

        repairOrder = ABRSRepairOrder()
        repairOrder.setPoster(AVUser.currentUser())
        repairOrder.setRepairType(.General)
        repairOrder.setTroubleLevel(.NotUrgent)
        repairOrder.setRepairStatus(.Waiting)

        photosEditorView = ItemPhotosEditorView(frame: CGRectZero)
        photosEditorView.showInTableView(tableView)

        weak var weakSelf = self
        photosEditorView.photoButtonDidTouchUpInsideBlock = {(photo: UIImage, index: Int) -> Void in
            let sheet = YAActionSheet(title: nil)
            sheet.setDestructiveButtonWithTitle("删除", block: { () -> Void in
                weakSelf?.photosEditorView.removeItemPhoto(photo)
            })
            sheet.setCancelButtonWithTitle("取消", block: nil)
            sheet.showInView(UIApplication.sharedApplication().keyboardWindow())
        }

        photosEditorView.addButtonDidTouchUpInsideBlock = {() -> Void in
            let sheet = YAActionSheet(title: "添加故障图片")
            sheet.addButtonWithTitle("相机", block: { () -> Void in
                let imagePicker = AppManager.sharedManager.rootNavigator.visibleViewController?.presentImagePickerController(.Camera)
                imagePicker?.delegate = weakSelf
            })

            sheet.addButtonWithTitle("相册", block: { () -> Void in
                let imagePicker = AppManager.sharedManager.rootNavigator.visibleViewController?.presentImagePickerController(.PhotoLibrary)
                imagePicker?.delegate = weakSelf
            })

            sheet.setCancelButtonWithTitle("取消", block: nil)

            sheet.showInView(UIApplication.sharedApplication().keyboardWindow())
        }
        
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
            cell.contentLabel?.text = repairOrder.repairType().stringValue

        case 1:
            cell.titleLabel?.text = "文字描述"
            cell.contentLabel?.text = repairOrder.troubleDescription()
            
        case 2:
            cell.titleLabel?.text = "紧急程度"
            cell.contentLabel?.text = repairOrder.troubleLevel().stringValue
            
        case 3:
            cell.titleLabel?.text = "地       点"
            cell.contentLabel?.text = repairOrder.address()
            
        default:
            cell.titleLabel?.text = ""
            cell.contentLabel?.text = ""
            
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        weak var weakSelf = self
        switch indexPath.row {
        case 1:
            let popTextField = JSPopTextField()
            popTextField.numberOfWords = 0
            popTextField.text = self.repairOrder.troubleDescription()
            popTextField.didEndEditingBlock = {(textField: JSPopTextField!) -> Void in
                weakSelf?.repairOrder.setTroubleDescription(textField.text)
                textField.dismiss()
                weakSelf?.tableView().reloadData()
            }
            popTextField.showInView(UIApplication.sharedApplication().keyWindow)

        case 2:
            ActionSheetStringPicker.showPickerWithTitle("选择紧急程度",
                rows: [
                    ABRSRepairTroubleLevel.NotUrgent.stringValue,
                    ABRSRepairTroubleLevel.Urgent.stringValue,
                    ABRSRepairTroubleLevel.VeryUrgent.stringValue,
                ],
                initialSelection: self.repairOrder.troubleLevel().rawValue,
                doneBlock: { (picker, selectIndex, selectString) -> Void in
                    weakSelf?.repairOrder.setTroubleLevel(ABRSRepairTroubleLevel(rawValue: selectIndex)!)
                    weakSelf?.tableView().reloadData()
            },
                cancelBlock: nil,
                origin: UIApplication.sharedApplication().keyboardWindow())

        case 3:
            let popTextField = JSPopTextField()
            popTextField.numberOfWords = 0
            popTextField.text = self.repairOrder.address()

            popTextField.didEndEditingBlock = {(textField: JSPopTextField!) -> Void in
                weakSelf?.repairOrder.setAddress(textField.text)
                textField.dismiss()
                weakSelf?.tableView().reloadData()
            }

            popTextField.showInView(UIApplication.sharedApplication().keyWindow)

        default:
            break
        }
    }
}

extension PublishRepairDataSource: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
            let editImage = info[UIImagePickerControllerEditedImage] as? UIImage
            if editImage != nil {
                self.photosEditorView.addItemPhoto(editImage!)
            }
            picker.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
