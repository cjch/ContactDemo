//
//  UserEditViewController.swift
//  ContactDemo
//
//  Created by chenjie on 16/6/28.
//  Copyright © 2016年 chenjie. All rights reserved.
//

import UIKit

protocol UserEditDelegate: NSObjectProtocol {
    func userEditDidUpdate(user: User)
}

class UserEditViewController: UIViewController {

    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var editDelegate: UserEditDelegate?
    var user = User()
    private var isNewContact = false
    
    class func getInstance() -> UserEditViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(String(self)) as! UserEditViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isNewContact = navigationController?.viewControllers.count <= 1
        if isNewContact {
            title = "New Contact"
            self.deleteButton.hidden = true
        } else {
            updateTextField()
            self.deleteButton.hidden = false
            self.deleteButton.addTarget(self, action: #selector(onDelete), forControlEvents: .TouchUpInside)
        }
        self.avatarButton.addTarget(self, action: #selector(onAvatar), forControlEvents: .TouchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(onCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(onDone))
        navigationItem.rightBarButtonItem?.enabled = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onTextFieldChanged), name: UITextFieldTextDidChangeNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: event response
    func onTextFieldChanged() {
        var doneEnable = zeroCheck()
        if doneEnable && !isNewContact {
            if firstNameField.text! == user.firstName
                && lastNameField.text! == user.lastName
                && phoneField.text! == user.phone {
                doneEnable = false
            }
        }
        navigationItem.rightBarButtonItem?.enabled = doneEnable
    }
    
    func onCancel() {
        view.endEditing(true)
        gotoPreviousPage()
    }
    
    func onDone() {
        view.endEditing(true)
        let nUser = User(firstName: firstNameField.text!, lastName: lastNameField.text!, phone: phoneField.text!)
        if isNewContact {
            UserDataManager.sharedInstance.insertUser(nUser)
        } else {
            nUser.id = user.id
            UserDataManager.sharedInstance.updateUser(nUser)
            editDelegate?.userEditDidUpdate(nUser)
        }
        gotoPreviousPage()
    }
    
    func onDelete() {
        view.endEditing(true)
        UserDataManager.sharedInstance.deleteUser(user)
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func onAvatar() {
        //TODO:更换头像
        
    }
    
    //MARK: Helper
    func zeroLength(textField: UITextField) -> Bool {
        return textField.text?.characters.count == 0
    }
    
    func zeroCheck() -> Bool {
        if zeroLength(firstNameField) {
            return false
        }
        if zeroLength(lastNameField) {
            return false
        }
        if zeroLength(phoneField) {
            return false
        }
        
        return true
    }
    
    func gotoPreviousPage() {
        if isNewContact {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController?.popViewControllerAnimated(false)
        }
    }
    
    func updateTextField() {
        firstNameField.text = user.firstName
        lastNameField.text = user.lastName
        phoneField.text = user.phone
    }

}

extension UserEditViewController: UITextFieldDelegate {
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == firstNameField {
            lastNameField.becomeFirstResponder()
        }
        
        if textField == lastNameField {
            phoneField.becomeFirstResponder()
        }
        
        if textField == phoneField {
            view.endEditing(true)
        }
        
        return true
    }
}
