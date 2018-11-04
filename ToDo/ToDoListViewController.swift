//
//  ViewController.swift
//  ToDo
//
//  Created by Filip on 26/10/2018.
//  Copyright © 2018 Filip. All rights reserved.
//

import UIKit


class ToDoListViewController: UITableViewController {
    
    
    var alertTimer: Timer?
    var remainingTime = 0
    var array: [String ] = ["Apple", "Banna", "Lemon", "Watermelon", "Orange", "Citrus", "Granate"]
    let deafults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let items = deafults.array(forKey: "ToDoListArray") as? [String] {
            
            array = items
            
        }
        
        
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
        self.deafults.set(self.array, forKey: "ToDoListArray")
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
            self.deafults.set(self.array, forKey: "ToDoListArray")
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
    
    
    @objc func countDown() {
        
        self.remainingTime += 1
        if (self.remainingTime > 0) {
            self.alertTimer?.invalidate()
            self.alertTimer = nil
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    
}


