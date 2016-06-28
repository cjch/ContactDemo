//
//  ContactsCell.swift
//  ContactDemo
//
//  Created by chenjie on 16/6/28.
//  Copyright © 2016年 chenjie. All rights reserved.
//

import UIKit

class ContactsCell: UITableViewCell {

    @IBOutlet private weak var AvatarButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var accessView: UIImageView!
    
    var user: User? {
        didSet {
            if let u = user {
                print(user)
                self.nameLabel.text = "\(u.lastName) \(u.firstName)"
            } else {
                self.nameLabel.text = nil;
            }
        }
    }
    
    var showAccessView = true {
        didSet {
            accessView.hidden = !showAccessView
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
