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
    case Normal = 1, GeneralMaintenance, TechnologyMaintenance
}

extension AVUser {
    func department() -> String {
        return self["department"] as! String
    }

    func role() -> ABRSUserRole {
        return ABRSUserRole(rawValue: self["abrsRole"] as! Int)!
    }
}

extension UIWindow {
    var visiableNavigator: UINavigationController? {
        var currentNavigator: UINavigationController? = nil

        var nextVC = self.rootViewController;

        while nextVC != nil {
            if (nextVC!.isKindOfClass(UINavigationController.self)) {
                currentNavigator = nextVC as? UINavigationController
            }

            if (nextVC!.presentedViewController != nil) {
                nextVC = nextVC!.presentedViewController
            } else if (nextVC!.isKindOfClass(UINavigationController.self)) {
                nextVC = (nextVC as! UINavigationController).visibleViewController
            } else if (nextVC!.isKindOfClass(UITabBarController.self)) {
                nextVC = (nextVC as! UITabBarController).selectedViewController
            } else {
                nextVC = nil
            }
        }
        
        return currentNavigator;
    }
}

extension UIViewController {
    func presentImagePickerController(sourceType: UIImagePickerControllerSourceType) -> UIImagePickerController? {
        if (UIImagePickerController.isSourceTypeAvailable(sourceType)) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = sourceType
            imagePickerController.allowsEditing = true

            imagePickerController.navigationBar.tintColor = UIColor.whiteColor()
            self.presentViewController(imagePickerController, animated: true, completion: nil)

            return imagePickerController
        }

        return nil
    }
}

extension String {
    func boundingRectWithConstraints(size: CGSize,
        attributes:[String: AnyObject!],
        limitedToNumberOfLines lines: Int) -> CGRect {
            let currentStr = self as NSString
            var constraintsHeight = size.height

            let font = attributes[NSFontAttributeName] as? UIFont
            if lines != 0 && font != nil {
                constraintsHeight = CGFloat(lines) * font!.lineHeight

                let ps = attributes[NSParagraphStyleAttributeName] as? NSMutableParagraphStyle

                if ps != nil {
                    constraintsHeight += CGFloat(lines) * ps!.lineSpacing
                }

            }

            return currentStr.boundingRectWithSize(CGSize(width: size.width, height: constraintsHeight),
                options: (.TruncatesLastVisibleLine | .UsesLineFragmentOrigin | .UsesFontLeading),
                attributes: attributes,
                context: nil)
    }
}
