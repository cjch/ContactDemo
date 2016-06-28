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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: event response
    func onCancel() {
        view.endEditing(true)
        gotoPreviousPage()
    }
    
    func onDone() {
        view.endEditing(true)
        if !checkValidate() {
            //TODO:输入错误说明
            if isNewContact {
                
            } else {
                
            }
            return
        }
        
        let user = User(firstName: firstNameField.text!, lastName: lastNameField.text!, phone: phoneField.text!)
        if isNewContact {
            UserDataManager.sharedInstance.insertUser(user)
        } else {
            UserDataManager.sharedInstance.updateUser(user)
            editDelegate?.userEditDidUpdate(user)
        }
        gotoPreviousPage()
    }
    
    func onDelete() {
        view.endEditing(true)
        UserDataManager.sharedInstance.deleteUser(user)
        gotoPreviousPage()
    }
    
    func onAvatar() {
        //TODO:更换头像
        
    }
    
    //MARK: Helper
    func zeroLengthOrEqual(textField: UITextField, str: String) -> Bool {
        return textField.text?.characters.count == 0 || (textField.text! == str)
    }
    
    func checkValidate() -> Bool {
        if zeroLengthOrEqual(firstNameField, str: user.firstName) {
            return false
        }
        if zeroLengthOrEqual(lastNameField, str: user.lastName) {
            return false
        }
        if zeroLengthOrEqual(phoneField, str: user.lastName) {
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
