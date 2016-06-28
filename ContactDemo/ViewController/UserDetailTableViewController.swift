//
//  UserDetailTableViewController.swift
//  ContactDemo
//
//  Created by chenjie on 16/6/28.
//  Copyright © 2016年 chenjie. All rights reserved.
//

import UIKit

class UserDetailTableViewController: UITableViewController {
    
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Detail"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(onEdit))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: String(UITableViewCell))
        tableView.registerNib(UINib(nibName: String(ContactsCell), bundle: nil), forCellReuseIdentifier: String(ContactsCell))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onEdit() {
        let editVC = UserEditViewController.getInstance()
        editVC.user = user
        editVC.editDelegate = self
        navigationController?.pushViewController(editVC, animated: false)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 20
        }
        
        if indexPath.section == 0 {
            return 64
        } else {
            return 54
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ContactsCell), forIndexPath: indexPath) as! ContactsCell
            cell.user = user
            cell.showAccessView = false
            cell.selectionStyle = .None
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(String(UITableViewCell), forIndexPath: indexPath)
        if indexPath.section == 1 && indexPath.row == 1 {
            cell.selectionStyle = .Default
            cell.textLabel?.text = "Phone:  \(user.phone)"
        } else {
            cell.selectionStyle = .None
            cell.textLabel?.text = nil
        }
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1 && indexPath.row == 1 {
            //TODO: 拨打电话
        }
    }
}

extension UserDetailTableViewController: UserEditDelegate {
    func userEditDidUpdate(user: User) {
        self.user = user
        tableView.reloadData()
    }
}
