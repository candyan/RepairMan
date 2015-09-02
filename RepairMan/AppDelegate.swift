//
//  AppDelegate.swift
//  RepairMan
//
//  Created by liuyan on 8/16/15.
//  Copyright © 2015 ABRS. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
}

// Applicaton Delegate
extension AppDelegate {
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.setupApplication()
        self.setupLeanCloud()
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        if AVUser.currentUser() == nil {
            self.window!.rootViewController = LaunchViewController(nibName: nil, bundle: nil)
        } else {
            self.window!.rootViewController = UINavigationController(rootViewController: HomeViewController())
        }
        
        self.window!.makeKeyAndVisible()
        
        return true
    }
}

extension AppDelegate {
    func setupApplication() {
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = UIColor(hex: 0x4A90E2)
        
        let titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "Helvetica", size: 18)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().titleTextAttributes = titleTextAttributes
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-1000, -100), forBarMetrics: .Default)
        let backButtonImage = UIImage(named: "NaviBack")?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 25, 0, 0), resizingMode: .Stretch)
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backButtonImage, forState: .Normal, barMetrics: .Default)
        
        // UIText Setup
        UITextField.appearance().tintColor = UIColor(hex: 0x4A90E2)
        UITextView.appearance().tintColor = UIColor(hex: 0x4A90E2)
        
        // UILabel Setup
        UILabel.appearance().backgroundColor = UIColor.clearColor()
        
        // UITableView Cell Setup
        UITableView.appearance().backgroundColor = UIColor.whiteColor()
        UITableView.appearance().backgroundView = nil
        UITableViewCell.appearance().backgroundColor = UIColor.whiteColor()
        
        
    }
    func setupLeanCloud() {
        ABRSRepairOrder.registerSubclass()
        AVOSCloud.setApplicationId("mr6gny1ipywksc4nzx39rnlsuok86z2shwwcsytfea15w1ls",
            clientKey: "vfmjw07qgbnv40v3x3t75hatrc7b4y0fjmy4ho8ry1mnno0k")
    }
}

