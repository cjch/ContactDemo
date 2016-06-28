//
//  UserDataManager.swift
//  ContactDemo
//
//  Created by chenjie on 16/6/27.
//  Copyright © 2016年 chenjie. All rights reserved.
//

import UIKit
import SQLite

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
                t.column(phone)
            }))
        } catch {
            print("Error: connection to database")
        }
    }
    
    //MARK: data access
    func getAllUsers() -> [User] {
        var items = [User]()
        do {
            for user in try db.prepare(userTable.order(lastName))  {
                let item = User()
                item.firstName = user[firstName]
                item.lastName = user[lastName]
                item.phone = user[phone]
                items.append(item)
            }
        }
        catch {
            print("Error: query all user")
        }
        return items
    }

    func insertUser(user: User) {
        let insert = userTable.insert(firstName <- user.firstName, lastName <- user.lastName, phone <- user.phone)
        do {
            try db.run(insert)
        } catch {
            print("Error: insert user");
        }
    }
    
    func updateUser(user: User) {
        
    }
    
    func deleteUser(user: User) {
        
    }
    
    func searchUser(str: String) -> [User] {
        return [User]()
    }
}
