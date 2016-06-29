//
//  SearchResultsViewController.swift
//  ContactDemo
//
//  Created by chenjie on 16/6/27.
//  Copyright © 2016年 chenjie. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var searchResults = [User]()
    
    private weak var container: UIViewController!
    
    class func getInstance(container: UIViewController) -> SearchResultsViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(String(self)) as! SearchResultsViewController
        vc.container = container
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.separatorStyle = .None
        tableView.registerNib(UINib(nibName: String(ContactsCell), bundle: nil), forCellReuseIdentifier: String(ContactsCell))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num = searchResults.count
        return num
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(ContactsCell)) as! ContactsCell
        cell.user = searchResults[indexPath.row];
        cell.showAccessView = false
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let detailVC = UserDetailTableViewController()
        detailVC.user = searchResults[indexPath.row]
        container.navigationController?.pushViewController(detailVC, animated: true)
    }
}