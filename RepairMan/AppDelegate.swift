//
//  AppDelegate.swift
//  RepairMan
//
//  Created by liuyan on 8/16/15.
//  Copyright © 2015 ABRS. All rights reserved.
//

import UIKit

enum ABRSUserRole{
    case normal
    case maintenance
}

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
        self.window!.rootViewController = LaunchViewController(nibName: nil, bundle: nil)
        self.window!.makeKeyAndVisible()
        
        AVUser.logInWithUsernameInBackground("陈悦", password: "123") { (user, error) -> Void in
            user["department"] = 1
            user["role"] = ABRSUserRole.normal
        }
        
        return true
    }
}

extension AppDelegate {
    func setupApplication() {
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = UIColor(hex: 0x4A90E2)
        
//        let titleTextAttributes = [NSFontAttributeName: UIFont(name: "Helvetica", size: 18),
//            NSForegroundColorAttributeName: UIColor.whiteColor()]
//        UINavigationBar.appearance().titleTextAttributes = titleTextAttributes
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-1000, -100), forBarMetrics: .Default)
        
//        [[UIBarButtonItem appearance]
//            setBackButtonBackgroundImage:[[UIImage imageNamed:@"NavigatorBack"]
//            resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0, 0)
//            resizingMode:UIImageResizingModeStretch]
//            forState:UIControlStateNormal
//            barMetrics:UIBarMetricsDefault];
        
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
        AVOSCloud.setApplicationId("mr6gny1ipywksc4nzx39rnlsuok86z2shwwcsytfea15w1ls",
            clientKey: "vfmjw07qgbnv40v3x3t75hatrc7b4y0fjmy4ho8ry1mnno0k")
    }
}

