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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.loadSubviews()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// subviews

extension RepairOrderCell {
    internal func loadSubviews() {
        
    }
}