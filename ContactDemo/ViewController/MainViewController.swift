//
//  MainViewController.swift
//  ContactDemo
//
//  Created by chenjie on 16/6/27.
//  Copyright © 2016年 chenjie. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var allUsers = [User]()
    private var searchController: UISearchController!
    private var searchResultsVC: SearchResultsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Contact"
        let addItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addUser))
        navigationItem.rightBarButtonItem = addItem
        
        searchResultsVC = SearchResultsViewController.getInstance(self)
        searchController = UISearchController(searchResultsController: searchResultsVC)
        searchController.searchResultsUpdater = self
        searchController.searchBar.frame = CGRect(x: 0, y: 0, width: 0, height: 44)
        
        //必须添加这行，否则搜索结果页会有一个高度为64的白条
        self.definesPresentationContext = true
        
        tableView.separatorStyle = .None
        tableView.registerNib(UINib(nibName: String(ContactsCell), bundle: nil), forCellReuseIdentifier: String(ContactsCell))
        
        onUserInfoChanged()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onUserInfoChanged), name: UserInfoChangedNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onUserInfoChanged() {
        allUsers = UserDataManager.sharedInstance.getAllUsers()
        if allUsers.count > 0 {
            tableView.tableHeaderView = searchController.searchBar
        } else {
            tableView.tableHeaderView = nil
        }
        tableView.reloadData()
    }
    
    func addUser() {
        let editVC = UserEditViewController.getInstance()
        let navVC = UINavigationController(rootViewController: editVC)
        presentViewController(navVC, animated: true, completion: nil)
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(ContactsCell)) as! ContactsCell
        cell.user = allUsers[indexPath.row]
        cell.showAccessView = true
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let detailVC = UserDetailTableViewController()
        detailVC.user = allUsers[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let text = searchController.searchBar.text!
        searchResultsVC.searchResults = UserDataManager.sharedInstance.searchUser(text)
        searchResultsVC.tableView.reloadData()
    }
}
