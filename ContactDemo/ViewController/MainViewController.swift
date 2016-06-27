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
    var searchController: UISearchController!
    let searchResultsVC = SearchResultsViewController.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Contact"
        
        searchController = UISearchController(searchResultsController: searchResultsVC)
        searchController.searchResultsUpdater = self
        searchController.searchBar.frame = CGRect(x: 0, y: 0, width: 0, height: 44)
        
        //必须添加这行，否则搜索结果页会有一个高度为64的白条
        self.definesPresentationContext = true
        
//        let user = User(firstName: "jie", lastName: "chen", phone: "12344")
//        for _ in 1...7 {
//            UserDataManager.sharedInstance.insertUser(user)
//        }
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: String(UITableViewCell))
        allUsers = UserDataManager.sharedInstance.getAllUsers()
        
        tableView.tableHeaderView = searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num = allUsers.count
        tableView.separatorStyle = num == 0 ? .None : .SingleLine
        return num
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(UITableViewCell))
        let user = allUsers[indexPath.row]
        cell?.textLabel?.text = "\(user.lastName) \(user.firstName)"
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let text = searchController.searchBar.text!
        print("searchBar text: \(text)")
        
        searchResultsVC.searchResults = allUsers
        searchResultsVC.tableView.reloadData()
    }
}
