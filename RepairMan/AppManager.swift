//
//  AppManager.swift
//  RepairMan
//
//  Created by Cherry on 15/9/3.
//  Copyright (c) 2015年 ABRS. All rights reserved.
//

import UIKit

class AppManager: NSObject {
    var rootNavigator: UINavigationController! = UINavigationController()
    
    static let sharedManager = AppManager()
}
