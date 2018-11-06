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
    var array = [Items]()
    //let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
        loadItems()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return array.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell" , for: indexPath)
        
        cell.textLabel?.text = array[indexPath.row].title
        
        // Ternary operator
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = array[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let name = array[indexPath.row]
        print(name.title)
        
        array[indexPath.row].done = !array[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        

        addedOrRemovedItem(titleText: "Successed Removed Item", messageText: array[indexPath.row].title)
        array.remove(at: indexPath.row)
        //self.defaults.set(self.array, forKey: "ToDoListArray")
        saveItems()
        
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
            
            let newItem = Items()
            newItem.title = toDoField.text!
            
            self.array.append(newItem)
            
            self.saveItems()
            
            //self.defaults.set(self.array, forKey: "ToDoListArray")
            
            self.addedOrRemovedItem(titleText: "Successed Added Item", messageText: toDoField.text!)
            
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
        
}

    
    func addedOrRemovedItem(titleText: String, messageText: String) {
        
        let addedOrRemovedItem = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        self.present(addedOrRemovedItem, animated: true, completion: nil)
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
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            
            let data = try encoder.encode(array)
            
            try data.write(to: dataFilePath!)
            
        } catch {
            
            print(error)
            
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
           
            do {
                
            array = try decoder.decode([Items].self, from: data)
                
            } catch {
                
                print(error)
            }
        
        }
    }
    
}


