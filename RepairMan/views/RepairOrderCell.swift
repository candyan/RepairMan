//
//  RepairOrderCell.swift
//  
//
//  Created by liuyan on 9/1/15.
//
//

import UIKit

class RepairOrderCell: UITableViewCell {
    
    var avatarImageView: UIImageView?
    var titleLabel: UILabel?
    var subTitleLabel: UILabel?
    var contentLabel: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.loadSubviews()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func heightForContent(contentText: String, limitedSize: CGSize) -> CGFloat {
        let contentRect = contentText.boundingRectWithConstraints(limitedSize,
            attributes: [NSFontAttributeName: UIFont.helveticaFontOfSize(14)],
            limitedToNumberOfLines: 0)
        return 15 + 60 + contentRect.height - UIFont.helveticaFontOfSize(14).lineHeight + 15
    }
}

// subviews

extension RepairOrderCell {
    internal func loadSubviews() {
        avatarImageView = UIImageView(frame: CGRectZero)
        self.contentView.addSubview(avatarImageView!)

        avatarImageView!.layer.cornerRadius = 4
        avatarImageView!.layer.masksToBounds = true
        avatarImageView!.backgroundColor = UIColor(hex: 0x999999)
        avatarImageView!.mas_makeConstraints { (maker) -> Void in
            maker.top.equalTo()(self.contentView).offset()(15)
            maker.width.and().height().mas_equalTo()(60)
            maker.leading.equalTo()(self.contentView).offset()(10)
        }

        titleLabel = UILabel(frame: CGRectZero)
        self.contentView.addSubview(titleLabel!)

        titleLabel!.font = UIFont.helveticaFontOfSize(16)
        titleLabel!.textColor = UIColor(hex: 0x333333)

        titleLabel!.mas_makeConstraints { (maker) -> Void in
            maker.top.equalTo()(self.avatarImageView)
            maker.leading.equalTo()(self.avatarImageView!.mas_trailing).offset()(10)
            maker.trailing.equalTo()(self.contentView).offset()(-10)
        }

        subTitleLabel = UILabel(frame: CGRectZero)
        self.contentView.addSubview(subTitleLabel!)

        subTitleLabel!.font = UIFont.helveticaFontOfSize(12)
        subTitleLabel!.textColor = UIColor(hex: 0x999999)

        subTitleLabel!.mas_makeConstraints { (maker) -> Void in
            maker.top.equalTo()(self.titleLabel!.mas_bottom).offset()(10)
            maker.leading.equalTo()(self.titleLabel)
            maker.trailing.equalTo()(self.contentView).offset()(-10)
        }

        contentLabel = UILabel(frame: CGRectZero)
        self.contentView.addSubview(contentLabel!)

        contentLabel!.font = UIFont.helveticaFontOfSize(14)
        contentLabel!.textColor = UIColor(hex: 0x666666)
        contentLabel!.numberOfLines = 0

        contentLabel!.mas_makeConstraints { (maker) -> Void in
            maker.top.equalTo()(self.avatarImageView!.mas_bottom).offset()(-14)
            maker.leading.equalTo()(self.avatarImageView!.mas_trailing).offset()(10)
            maker.trailing.equalTo()(self.contentView).offset()(-10)
        }

        let bottomSL = YASeparatorLine(frame: CGRectZero, lineColor: UIColor(hex: 0x000000, alpha: 0.2), lineWidth: 1)
        self.contentView.addSubview(bottomSL!)

        bottomSL!.mas_makeConstraints { (maker) -> Void in
            maker.bottom.equalTo()(self.contentView)
            maker.height.mas_equalTo()(0.5)
            maker.leading.equalTo()(self.contentView).offset()(10)
            maker.trailing.equalTo()(self.contentView).offset()(-10)
        }
    }
}