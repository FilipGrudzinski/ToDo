//
//  ViewController.swift
//  ToDo
//
//  Created by Filip on 26/10/2018.
//  Copyright © 2018 Filip. All rights reserved.
//

import UIKit
import RealmSwift


class ToDoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var toDoItems: Results<Item>?
   
    
    var selectedCategory: Category? {
        didSet{ // run only when category have value
            
            loadItems()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if item.date == nil {

                cell.detailTextLabel?.text = ""

            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMM yyyy HH:mm"
            
                let result = formatter.string(from: item.date!)
                
                cell.detailTextLabel?.text = result

            }

            // Ternary operator
            // value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            
            cell.textLabel?.text = "No items Added"
            
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            
            do {
                
                try realm.write {
                    item.done = !item.done
                }
                
            } catch {
                
                print(error)
                
            }
            
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //Mark - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        pop()
        
    }
    
    func pop() {
        
        var toDoField = UITextField()
        
        
        let alertController = UIAlertController(title: "Add New To Do", message: "", preferredStyle: .alert)
        
        // Create an OK Button
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        
                        let newItem = Item()
                        
                        newItem.title = toDoField.text!

                        newItem.date = Date()
                        
                        currentCategory.items.append(newItem)
                        
                    }
                } catch {
                    print(error)
                }
                
            }
            
            self.tableView.reloadData()
            
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
                    textField.clearButtonMode = UITextField.ViewMode.whileEditing
                    
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
        self.dismiss(animated: true, completion: nil)
        
        
    }

    func loadItems() {

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "date", ascending: true)
        
        
        self.tableView.reloadData()
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let item = self.toDoItems?[indexPath.row] {
            
            self.addedOrRemovedItem(titleText: "Successed Removed Category", messageText: item.title)
            
            do {
                
                try self.realm.write {
                    self.realm.delete(item)
                }
                
            } catch {
                
                print(error)
                
            }
            
        }
        
    }
    
}

//Mark Extension SearchBarDelegate

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: false)
       // [c] case insensitive: lowercase & uppercase values are treated the same // [d] diacritic insensitive: special characters treated as the base character
        tableView.reloadData()
        
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
       // searchBySearchBar(searchText: searchText)
        
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
                
            }
            
        }
        
    }
    
    func searchBySearchBar(searchText: String) {

        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "title", ascending: true)
        // [c] case insensitive: lowercase & uppercase values are treated the same // [d] diacritic insensitive: special characters treated as the base character
        tableView.reloadData()

    }
    
}

