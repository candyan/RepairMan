//
//  ABRSProfileHeader.swift
//  RepairMan
//
//  Created by cherry on 15/8/30.
//  Copyright (c) 2015年 ABRS. All rights reserved.
//

import UIKit

class ABRSProfileHeader: UIView {

    var avatarImageView: UIImageView?
    var titleLabel: UILabel?
    var subtitleLabel: UILabel?
    var operationButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadSubviews()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ABRSProfileHeader {
    func loadSubviews() {
        avatarImageView = UIImageView()
        self.addSubview(avatarImageView!)
        
        self.avatarImageView?.layer.cornerRadius = 30
        self.avatarImageView?.layer.masksToBounds = true
        
        self.avatarImageView?.backgroundColor = UIColor.grayColor()
        
        avatarImageView!.mas_makeConstraints({ (maker) -> Void in
            maker.width.equalTo()(60)
            maker.height.equalTo()(60)
            maker.top.equalTo()(self).offset()(30);
            maker.centerX.equalTo()(self)
        })
        
        titleLabel = UILabel()
        self.addSubview(titleLabel!)
        
        titleLabel?.font = UIFont(name: "Helvetica", size: 16)
        titleLabel?.textColor = UIColor(hex: 0x333333)
        
        titleLabel!.mas_makeConstraints { (maker) -> Void in
            maker.top.equalTo()(self.avatarImageView?.mas_bottom).offset()(30)
            maker.centerX.equalTo()(self)
        }
        
        subtitleLabel = UILabel()
        self.addSubview(subtitleLabel!)
        
        subtitleLabel?.font = UIFont(name: "Helvetica", size: 14)
        subtitleLabel?.textColor = UIColor(hex: 0x333333)
        
        subtitleLabel!.mas_makeConstraints { (maker) -> Void in
            maker.top.equalTo()(self.titleLabel?.mas_bottom).offset()(15)
            maker.centerX.equalTo()(self)
        }
        
        operationButton = UIButton.buttonWithType(.Custom) as? UIButton
        self.addSubview(operationButton!)
        
        operationButton!.mas_makeConstraints { (maker) -> Void in
            maker.top.equalTo()(self.subtitleLabel!.mas_bottom).offset()(30)
            maker.height.mas_equalTo()(44)
            maker.centerX.equalTo()(self)
        }
        
        operationButton?.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15)
        
        operationButton?.layer.cornerRadius = 22
        operationButton?.layer.masksToBounds = true
        operationButton?.backgroundColor = UIColor(hex: 0x4A90E2)
        operationButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        operationButton?.titleLabel?.font = UIFont(name: "Helvetica", size: 17)
    }
}
