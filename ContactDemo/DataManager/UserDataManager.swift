//
//  UserDataManager.swift
//  ContactDemo
//
//  Created by chenjie on 16/6/27.
//  Copyright © 2016年 chenjie. All rights reserved.
//

import UIKit
import SQLite

public let UserInfoChangedNotification = "com.jch.user.info.changed"

class UserDataManager: NSObject {
    
    class var sharedInstance: UserDataManager {
        struct StaticManager {
            static let instance = UserDataManager()
        }
        return StaticManager.instance
    }
    
    private var db: Connection!
    private var userTable: Table!
    
    private let id = Expression<Int64>("id")
    private let firstName = Expression<String>("firstName")
    private let lastName = Expression<String>("lastName")
    //sqlite不存在CONCAT方法，因此增加一个字段
    private let fullName = Expression<String>("fullName")
    private let phone = Expression<String>("phone")
    
    private override init() {
        super.init()
        
        do {
            let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let dbpath = "\(path.first!)/db.sqlite3"
            db = try Connection(dbpath)
            
            userTable = Table("users")
            
            try db.run(userTable.create(ifNotExists: true, block: { t in
                t.column(id, primaryKey: true)
                t.column(firstName)
                t.column(lastName)
                t.column(fullName)
                t.column(phone)
            }))
        } catch {
            print("Error: connection to database\n \(error)")
        }
    }
    
    //MARK: data access
    func getAllUsers() -> [User] {
        var items = [User]()
        do {
            for user in try db.prepare(userTable.order(lastName)) {
                let item = User()
                item.id = user[id]
                item.firstName = user[firstName]
                item.lastName = user[lastName]
                item.phone = user[phone]
                items.append(item)
            }
        }
        catch {
            print("Error: query all user\n \(error)")
        }
        return items
    }

    func insertUser(user: User) {
        let insert = userTable.insert(firstName <- user.firstName,
                                      lastName <- user.lastName,
                                      fullName <- "\(user.firstName) \(user.lastName)",
                                      phone <- user.phone)
        do {
            try db.run(insert)
            NSNotificationCenter.defaultCenter().postNotificationName(UserInfoChangedNotification, object: nil)
        } catch {
            print("Error: insert user\n \(error)");
        }
    }
    
    func updateUser(user: User) {
        let record = userTable.filter(id == user.id!)
        do {
            try db.run(record.update(firstName <- user.firstName, lastName <- user.lastName, phone <- user.phone))
            NSNotificationCenter.defaultCenter().postNotificationName(UserInfoChangedNotification, object: nil)
        } catch {
            print("Error: update user\n \(error)");
        }
    }
    
    func deleteUser(user: User) {
        let record = userTable.filter(id == user.id!)
        do {
            try db.run(record.delete())
            NSNotificationCenter.defaultCenter().postNotificationName(UserInfoChangedNotification, object: nil)
        } catch {
            print("Error: delete user\n \(error)");
        }
    }
    
    func searchUser(str: String) -> [User] {
        var items = [User]()
        
        do {
            print("search: \(str)")
            for user in try db.prepare(userTable.filter(fullName.like("%\(str)%")).order(lastName)) {
                let item = User()
                item.id = user[id]
                item.firstName = user[firstName]
                item.lastName = user[lastName]
                item.phone = user[phone]
                items.append(item)
            }
        }
        catch {
            print("Error: search user\n \(error)")
        }
        
        return items
    }
}
