//
//  RepairEditEntryCell.swift
//  
//
//  Created by liuyan on 9/1/15.
//
//

import UIKit

class RepairEditEntryCell: UITableViewCell {
    
    var titleLabel: UILabel?
    var contentLabel: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.loadSubviews()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.loadSubviews()
    }

}

// load subviews
extension RepairEditEntryCell {
    private func loadSubviews() {
        titleLabel = UILabel(frame: CGRectZero)
        self.contentView.addSubview(titleLabel!)
        
        titleLabel!.font = UIFont(name: "Helvetica", size: 16)
        titleLabel!.textColor = UIColor(hex: 0x333333)
        
        titleLabel!.mas_makeConstraints { (maker) -> Void in
            maker.leading.equalTo()(self.contentView).offset()(10)
            maker.centerY.equalTo()(self.contentView)
        }
        
        contentLabel = UILabel(frame: CGRectZero)
        self.contentView.addSubview(contentLabel!)
        
        contentLabel!.font = UIFont(name: "Helvetica", size: 16)
        contentLabel!.textColor = UIColor(hex: 0x333333)
        contentLabel!.textAlignment = .Justified
        
        contentLabel!.mas_makeConstraints { (maker) -> Void in
            maker.centerY.equalTo()(self.contentView)
            maker.leading.equalTo()(self.titleLabel!.mas_trailing).offset()(95)
            maker.trailing.equalTo()(self.contentView).offset()(-25)
        }
        
        let accessoryImageView = UIImageView(image: UIImage(name: "AccessoryArrow"))
        self.contentView.addSubview(accessoryImageView)
        
        accessoryImageView.mas_makeConstraints { (maker) -> Void in
            maker.trailing.equalTo()(self.contentView).offset()(-10)
            maker.centerY.equalTo()(self.contentView)
        }
        
        let bottomSL = YASeparatorLine(frame: CGRectZero, lineColor: UIColor(hex: 0x000000, alpha: 0.2), lineWidth: 1)
        self.contentView.addSubview(bottomSL)
        
        bottomSL.mas_makeConstraints { (maker) -> Void in
            maker.width.equalTo()(self.contentView).offset()(-20)
            maker.centerX.and().bottom().equalTo()(self.contentView)
            maker.height.mas_equalTo()(0.5)
        }
    }
}
