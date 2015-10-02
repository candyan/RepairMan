

//
//  LoginViewController.swift
//  RepairMan
//
//  Created by cherry on 15/8/23.
//  Copyright (c) 2015年 ABRS. All rights reserved.
//

import UIKit

@objc protocol LoginViewControllerDelegate: NSObjectProtocol {
    optional func loginViewController(loginVC: LoginViewController, didFinishLoginWithInfo info: [String: AnyObject!])
}

class LoginViewController: UIViewController {
    
    weak var delegate: LoginViewControllerDelegate?
    var nextButton: UIButton?
    var nameTextField: UITextField?
    var passwordTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupNavigator()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.loadSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension LoginViewController {
    
    private func loadSubviews() {
        nameTextField = UITextField.loginTextField("手机号")
        self.view.addSubview(nameTextField!)
        nameTextField!.delegate = self
        
        nameTextField!.mas_makeConstraints({ (maker) -> Void in
            maker.width.mas_equalTo()(200)
            maker.centerX.equalTo()(self.view)
            maker.height.mas_equalTo()(50)
            maker.top.equalTo()(self.view).offset()(40)
        })
        
        passwordTextField = UITextField.loginTextField("密码")
        self.view.addSubview(passwordTextField!)
        passwordTextField!.delegate = self
        
        passwordTextField!.secureTextEntry = true
        
        passwordTextField!.mas_makeConstraints { (maker) -> Void in
            maker.width.equalTo()(self.nameTextField!)
            maker.centerX.equalTo()(self.nameTextField!)
            maker.height.equalTo()(self.nameTextField!)
            maker.top.equalTo()(self.nameTextField!.mas_bottom)
        }
        
        nextButton = UIButton(frame: CGRectZero)
        self.view.addSubview(nextButton!)
        
        nextButton!.mas_makeConstraints { (maker) -> Void in
            maker.width.equalTo()(200)
            maker.height.equalTo()(44)
            maker.top.equalTo()(self.passwordTextField!.mas_bottom).offset()(20);
            maker.centerX.equalTo()(self.view)
        }
        
        nextButton!.layer.cornerRadius = 22
        nextButton!.backgroundColor = UIColor(hex: 0x4A90E2)
        nextButton!.setTitle("登录", forState: .Normal)
        nextButton!.titleLabel?.font = UIFont(name: "Helvetica", size: 17)
        nextButton!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        nextButton!.addTarget(self, action: "nextButtonTouchUpInsideHandler:", forControlEvents: .TouchUpInside)
    }
    
    private func setupNavigator() {
        self.title = "登录"
        
        weak var weakSelf = self
        let closeBarButtonItems = UIBarButtonItem.barButtonItemsWithImage(UIImage(named: "NaviClose"),
            actionBlock: { () -> Void in
                weakSelf?.dismissViewControllerAnimated(true, completion: nil)
        })
        self.navigationItem.leftBarButtonItems = closeBarButtonItems as? [UIBarButtonItem]
    }
    
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LoginViewController {
    internal func nextButtonTouchUpInsideHandler(sender: UIButton?) {
        weak var weakSelf = self
        if self.nameTextField?.text.isEmpty == false &&
           self.passwordTextField?.text.isEmpty == false {
            MBProgressHUD.showProgressHUDWithText("登录中...")
            
            AVUser.logInWithMobilePhoneNumberInBackground(self.nameTextField?.text,
                password: self.passwordTextField?.text,
                block: { (user, error) -> Void in
                    if error == nil && user != nil {
                        MBProgressHUD.hideHUDForView(UIApplication.sharedApplication().keyboardWindow(), animated: false)
                        AVUser.changeCurrentUser(user, save: true)
                        weakSelf?.delegate?.loginViewController!(weakSelf!, didFinishLoginWithInfo: ["LoginUser": user])
                    } else {
                        MBProgressHUD.showHUDWithText("登录失败", complete: nil)
                    }
            })
        }
    }
}

extension UITextField {
    private static func loginTextField(placeholder: String) -> UITextField! {
        let textField = UITextField(frame: CGRectZero)
        textField.placeholder = placeholder
        textField.font = UIFont(name: "helvetica", size: 13)
        textField.textColor = UIColor(hex: 0x333333)
        textField.returnKeyType = .Done
        
        let bottomSL = YASeparatorLine(frame: CGRectZero, lineColor: UIColor(hex: 0x000000, alpha: 0.2), lineWidth: 1)
        textField.addSubview(bottomSL)
        
        bottomSL.mas_makeConstraints { (maker) -> Void in
            maker.leading.equalTo()(textField)
            maker.trailing.equalTo()(textField)
            maker.height.mas_equalTo()(0.5)
            maker.bottom.equalTo()(textField)
        }
        
        return textField
    }
}
