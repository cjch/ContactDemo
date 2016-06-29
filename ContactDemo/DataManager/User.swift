//
//  User.swift
//  ContactDemo
//
//  Created by chenjie on 16/6/27.
//  Copyright © 2016年 chenjie. All rights reserved.
//

import UIKit

class User: NSObject {
    var id: Int64?
    var firstName: String!
    var lastName: String!
    var phone: String!
    //暂时不实现该属性及其相关的需求
    var avatar: UIImage?
    
    init(firstName: String, lastName: String, phone: String) {
        super.init()
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
    }
    
    override convenience init() {
        self.init(firstName: "", lastName: "", phone: "")
    }
}
