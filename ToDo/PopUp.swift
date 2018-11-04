//
//  PopUp.swift
//  ToDo
//
//  Created by Filip on 27/10/2018.
//  Copyright © 2018 Filip. All rights reserved.
//

import UIKit



//Mark -  popUp function by old/longer way

//    var toDoField = UITextField()
//
//    var alert : UIAlertController?
//
//    @objc func alertTextFieldDidChange(_ sender: UITextField) {
//        if sender.text!.trimmingCharacters(in: .whitespaces).isEmpty {
//            print("spacje")
//        } else {
//
//            alert?.actions[0].isEnabled = sender.text!.count > 0
//
//        }
//
//
//    }
//
//    func testAlert() {
//
//        //1. Create the alert controller.
//        alert = UIAlertController(title: "Add New To Do", message: "", preferredStyle: .alert)
//
//        //2. Add the text field. If empty, the target action will disable yesAction
//        alert?.addTextField(configurationHandler: { (textFieldAlert) -> Void in
//            textFieldAlert.placeholder = "Enter your name"
//            textFieldAlert.autocorrectionType = UITextAutocorrectionType.yes
//            textFieldAlert.clearButtonMode = UITextField.ViewMode.whileEditing
//            textFieldAlert.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
//            self.toDoField = textFieldAlert
//        })
//
//        //3. Grab the value from the text field.
//        let action = UIAlertAction(title: "Add", style: .default, handler: { (action) -> Void in
//
//            self.array.append(self.toDoField.text!)
//            self.tableView.reloadData()
//            self.addedItem()
//
//        })
//
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//
//        action.isEnabled = false          // Initially disabled
//        alert?.addAction(action)
//        alert?.addAction(cancelAction)
//
//        self.present(alert!, animated: true, completion: nil)
//
//    }
//
//    //Mark - PopUp Functions
//    func addedItem() {
//
//        let addedItem = UIAlertController(title: "Successed Added Item", message: "\(toDoField.text!)", preferredStyle: .alert)
//        self.present(addedItem, animated: true, completion: nil)
//        self.alertTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(ToDoListViewController.countDown), userInfo: nil, repeats: true)
//
//
//    }
//
//    func removedItem(item: String) {
//
//        let removedItem = UIAlertController(title: "Successed Removed Item", message: "\(item)", preferredStyle: .alert)
//        self.present(removedItem, animated: true, completion: nil)
//        self.alertTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(ToDoListViewController.countDown), userInfo: nil, repeats: true)
//
//
//    }
//
//

//        func addedItem(titleText: String, messageText: String) {
//
//            let addedItem = UIAlertController(title: "Successed Added Item", message: "\(toDoField.text!)", preferredStyle: .alert)
//            self.present(addedItem, animated: true, completion: nil)
//            self.alertTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(ToDoListViewController.countDown), userInfo: nil, repeats: true)
//
//
//        }


//    func removedItem(item: String) {
//
//        let removedItem = UIAlertController(title: "Successed Removed Item", message: "\(item)", preferredStyle: .alert)
//        self.present(removedItem, animated: true, completion: nil)
//        self.alertTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(ToDoListViewController.countDown), userInfo: nil, repeats: true)
//
//    }
