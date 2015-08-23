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
    var departmentTextField: UITextField?
    var phoneNumberTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.loadSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension LoginViewController {
    
    internal func loadSubviews() {
        nameTextField = UITextField.loginTextField("姓名")
        self.view.addSubview(nameTextField!)
        nameTextField!.delegate = self
        
        nameTextField!.mas_makeConstraints({ (maker) -> Void in
            maker.width.mas_equalTo()(150)
            maker.centerX.equalTo()(self.view)
            maker.height.mas_equalTo()(50)
            maker.top.equalTo()(self.view).offset()(40)
        })
        
        departmentTextField = UITextField.loginTextField("部门")
        self.view.addSubview(departmentTextField!)
        departmentTextField!.delegate = self
        
        departmentTextField!.mas_makeConstraints { (maker) -> Void in
            maker.width.equalTo()(self.nameTextField!)
            maker.centerX.equalTo()(self.nameTextField!)
            maker.height.equalTo()(self.nameTextField!)
            maker.top.equalTo()(self.nameTextField!.mas_bottom)
        }
        
        phoneNumberTextField = UITextField.loginTextField("手机号")
        self.view.addSubview(phoneNumberTextField!)
        phoneNumberTextField!.delegate = self
        
        phoneNumberTextField!.mas_makeConstraints { (maker) -> Void in
            maker.width.equalTo()(self.nameTextField!)
            maker.centerX.equalTo()(self.nameTextField!)
            maker.height.equalTo()(self.nameTextField!)
            maker.top.equalTo()(self.departmentTextField!.mas_bottom)
        }
        phoneNumberTextField?.keyboardType = .PhonePad
        
        nextButton = UIButton(frame: CGRectZero)
        self.view.addSubview(nextButton!)
        
        nextButton!.mas_makeConstraints { (maker) -> Void in
            maker.width.equalTo()(150)
            maker.height.equalTo()(44)
            maker.top.equalTo()(self.phoneNumberTextField!.mas_bottom).offset()(10);
            maker.centerX.equalTo()(self.view)
        }
        
        nextButton!.layer.cornerRadius = 22
        nextButton!.backgroundColor = UIColor(hex: 0x4A90E2)
        nextButton!.setTitle("下一步", forState: .Normal)
        nextButton!.titleLabel?.font = UIFont(name: "Helvetica", size: 17)
        nextButton!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        nextButton!.addTarget(self, action: "nextButtonTouchUpInsideHandler:", forControlEvents: .TouchUpInside)
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
        if self.nameTextField?.text.isEmpty == false &&
           self.departmentTextField?.text.isEmpty == false &&
            self.phoneNumberTextField?.text.isEmpty == false {
                let info: [String: AnyObject!] = ["name": self.nameTextField?.text,
                    "department": self.departmentTextField?.text,
                    "phoneNumber": self.phoneNumberTextField?.text]
                self.delegate?.loginViewController?(self, didFinishLoginWithInfo: info)
        }
    }
}

extension UITextField {
    static func loginTextField(placeholder: String) -> UITextField! {
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
