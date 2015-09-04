//
//  LaunchViewController.swift
//  RepairMan
//
//  Created by cherry on 15/8/23.
//  Copyright (c) 2015年 ABRS. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    var launchImageView: UIImageView?
    var rightOperationButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.loadSubviews()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension LaunchViewController {
    internal func loadSubviews() {
        launchImageView = UIImageView(frame: CGRectZero)
        self.view.addSubview(launchImageView!)
        
        launchImageView!.mas_makeConstraints { (maker) -> Void in
            maker.edges.equalTo()(self.view)
        }
        
        rightOperationButton = UIButton.launchButton("登录", color: UIColor(hex: 0x4A90E2))
        self.view.addSubview(rightOperationButton!)
        
        rightOperationButton!.mas_makeConstraints { (maker) -> Void in
            maker.leading.equalTo()(self.view).offset()(50)
            maker.trailing.equalTo()(self.view).offset()(-50)
            maker.bottom.equalTo()(self.view).offset()(-30)
            maker.height.mas_equalTo()(44)
        }
        rightOperationButton?.addTarget(self, action: "rightOperationButtonTouchUpInsideHandler:", forControlEvents: .TouchUpInside)
    }
}

extension LaunchViewController {
    
    internal func rightOperationButtonTouchUpInsideHandler(sender: UIButton?) {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        self.presentViewController(UINavigationController(rootViewController: loginVC), animated: true, completion: nil)
    }

    internal func leftOperationButtonTouchUpInsideHandler(sender: UIButton?) {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        self.presentViewController(UINavigationController(rootViewController: loginVC), animated: true, completion: nil)
    }
}

extension LaunchViewController : LoginViewControllerDelegate {
    func loginViewController(loginVC: LoginViewController, didFinishLoginWithInfo info: [String : AnyObject!]) {
        loginVC.dismissViewControllerAnimated(false, completion: nil)
        AppManager.sharedManager.rootNavigator.setViewControllers([HomeViewController()], animated: false)
        AppManager.sharedManager.rootNavigator.navigationBarHidden = false
    }
}

extension UIButton {
    static func launchButton(title: String!, color: UIColor!) -> UIButton! {
        let button = UIButton(frame: CGRectZero)
        
        button.layer.cornerRadius = 22
        button.backgroundColor = color
        button.setTitle(title, forState: .Normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 17)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        return button
    }
}
