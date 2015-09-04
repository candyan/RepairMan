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
    var segmentLabel: UILabel?

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

        //load avatar image view
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

        //load title label
        titleLabel = UILabel()
        self.addSubview(titleLabel!)
        
        titleLabel?.font = UIFont(name: "Helvetica", size: 16)
        titleLabel?.textColor = UIColor(hex: 0x333333)
        
        titleLabel!.mas_makeConstraints { (maker) -> Void in
            maker.top.equalTo()(self.avatarImageView?.mas_bottom).offset()(30)
            maker.centerX.equalTo()(self)
        }

        //load subtitle label
        subtitleLabel = UILabel()
        self.addSubview(subtitleLabel!)
        
        subtitleLabel?.font = UIFont(name: "Helvetica", size: 14)
        subtitleLabel?.textColor = UIColor(hex: 0x333333)
        
        subtitleLabel!.mas_makeConstraints { (maker) -> Void in
            maker.top.equalTo()(self.titleLabel?.mas_bottom).offset()(15)
            maker.centerX.equalTo()(self)
        }

        //load operation button
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

        segmentLabel = UILabel()
        self.addSubview(segmentLabel!)

        segmentLabel?.font = UIFont(name: "Helvetica", size: 14)
        segmentLabel?.textColor = UIColor(hex: 0x666666)

        segmentLabel!.mas_makeConstraints { (maker) -> Void in
            maker.centerY.equalTo()(self.mas_bottom)
            maker.centerX.equalTo()(self)
        }

        //load bottom separator line
        let leftSL = YASeparatorLine(frame: CGRectZero, lineColor: UIColor(hex: 0x000000, alpha: 0.2), lineWidth: 1)
        self.addSubview(leftSL!)

        leftSL!.mas_makeConstraints { (maker) -> Void in
            maker.centerY.equalTo()(self.segmentLabel)
            maker.height.mas_equalTo()(0.5)
            maker.leading.equalTo()(self).offset()(10)
            maker.trailing.equalTo()(self.segmentLabel?.mas_leading).offset()(-10)
        }

        let rightSL = YASeparatorLine(frame: CGRectZero, lineColor: UIColor(hex: 0x000000, alpha: 0.2), lineWidth: 1)
        self.addSubview(rightSL!)

        rightSL!.mas_makeConstraints { (maker) -> Void in
            maker.centerY.equalTo()(self.segmentLabel)
            maker.height.mas_equalTo()(0.5)
            maker.leading.equalTo()(self.segmentLabel?.mas_trailing).offset()(10)
            maker.trailing.equalTo()(self).offset()(-10)
        }
    }
}
