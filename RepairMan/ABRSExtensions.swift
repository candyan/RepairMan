//
//  ABRSExtensions.swift
//  RepairMan
//
//  Created by liuyan on 9/1/15.
//  Copyright (c) 2015 ABRS. All rights reserved.
//

import Foundation

extension MBProgressHUD {
    public static func showHUDWithText(text: String!, complete completeBlock: MBProgressHUDCompletionBlock?) -> MBProgressHUD! {
        var hud = MBProgressHUD(forView: UIApplication.sharedApplication().keyboardWindow())
        if hud == nil {
            hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyboardWindow()!, animated: true)
        }
        
        hud.mode = .Text
        hud.labelText = text
        hud.margin = 25.0
        hud.removeFromSuperViewOnHide = true
        
        hud.completionBlock = completeBlock
        
        hud.hide(true, afterDelay: 2.0)

        return hud
    }
    
    public static func showProgressHUDWithText(text: String!) -> MBProgressHUD! {
        var hud = MBProgressHUD(forView: UIApplication.sharedApplication().keyboardWindow())
        if hud == nil {
            hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyboardWindow()!, animated: true)
        }
        
        hud.mode = .Indeterminate
        hud.labelText = text
        hud.margin = 25.0
        hud.removeFromSuperViewOnHide = true
        
        return hud
    }
}

enum ABRSUserRole: Int {
    case Normal = 1, GeneralMaintenance
}

extension AVUser {
    var department: String {
        get {
            return self["department"] as! String
        }
        set(newDepartment) {
            self["department"] = newDepartment
        }
    }
    
    var role: ABRSUserRole {
        get {
            return ABRSUserRole(rawValue: self["abrs_role"] as! Int)!
        }
        set(newRole) {
            self["abrs_role"] = newRole.rawValue
        }
    }
}