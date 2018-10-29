//
//  ViewController.swift
//  ToDo
//
//  Created by Filip on 26/10/2018.
//  Copyright © 2018 Filip. All rights reserved.
//

import UIKit


class ToDoListViewController: UITableViewController, UITextFieldDelegate {
    
    
    var alertTimer: Timer?
    var remainingTime = 0
    var array: [String ] = ["Apple", "Banna", "Lemon", "Watermelon", "Orange", "Citrus", "Granate"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return array.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell" , for: indexPath)
        
        cell.textLabel?.text = array[indexPath.row]
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let name = array[indexPath.row]
        print(name)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        } else {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        

    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
       removedItem(item: array[indexPath.row])
       array.remove(at: indexPath.row)
      
       tableView.reloadData()
       
    }
    
    //Mark - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        pop()
        
       //testAlert()
        
    }
    
    func pop() {
        
        var toDoField = UITextField()
        
        
        let alertController = UIAlertController(title: "Add New To Do", message: "", preferredStyle: .alert)
        
        // Create an OK Button
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            
            self.array.append(toDoField.text!)
            self.tableView.reloadData()
            addedItem()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // Add the OK Button to the Alert Controller
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        addAction.isEnabled = false
        
        // Add a text field to the alert controller
        alertController.addTextField { (textField) in
            
            // Observe the UITextFieldTextDidChange notification to be notified in the below block when text is changed
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:
                {_ in
                    // Being in this block means that something fired the UITextFieldTextDidChange notification.
                    
                    // Access the textField object from alertController.addTextField(configurationHandler:) above and get the character count of its non whitespace characters
                    let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                    let textIsNotEmpty = textCount > 0
                    
                    // If the text contains non whitespace characters, enable the OK Button
                    addAction.isEnabled = textIsNotEmpty
                    
            })
            
            toDoField = textField
        }
        present(alertController, animated: true, completion: nil)
        
        //Mark - PopUp Functions
            func addedItem() {
        
                let addedItem = UIAlertController(title: "Successed Added Item", message: "\(toDoField.text!)", preferredStyle: .alert)
                self.present(addedItem, animated: true, completion: nil)
                self.alertTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(ToDoListViewController.countDown), userInfo: nil, repeats: true)
        
        
            }
        
    }
    
    func removedItem(item: String) {
        
        let removedItem = UIAlertController(title: "Successed Removed Item", message: "\(item)", preferredStyle: .alert)
        self.present(removedItem, animated: true, completion: nil)
        self.alertTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(ToDoListViewController.countDown), userInfo: nil, repeats: true)
        
        
    }

    
    //Mark - New popUp function
        
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
    @objc func countDown() {

        self.remainingTime += 1
        if (self.remainingTime > 0) {
            self.alertTimer?.invalidate()
            self.alertTimer = nil
            self.dismiss(animated: true, completion: nil)

        }
    }
//
//

   
}


