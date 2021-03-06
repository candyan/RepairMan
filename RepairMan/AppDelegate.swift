//
//  AppDelegate.swift
//  RepairMan
//
//  Created by Cherry on 8/16/15.
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
        self.window!.rootViewController = AppManager.sharedManager.rootNavigator

        if AVUser.currentUser() == nil {
            AppManager.sharedManager.rootNavigator.setViewControllers([LaunchViewController()], animated: false)
            AppManager.sharedManager.rootNavigator.navigationBarHidden = true
        } else {
            AppManager.sharedManager.rootNavigator.setViewControllers([HomeViewController()], animated: false)
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
        AVOSCloud.setApplicationId("XBvsVbmtLdgaWp4BX5lQx1b2",
            clientKey: "mS6YsrOQswTDVbSh7r0gvgzI")
    }
}

