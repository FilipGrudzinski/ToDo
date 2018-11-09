//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Filip on 06/11/2018.
//  Copyright © 2018 Filip. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadCategories()
        
        
    }
    
    // MARK: - Table view data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 // nil coloasing operator
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories yet"
        //cell.backgroundColor = HexColor(categories?[indexPath.row].name ?? "#1D9BF6")
        cell.delegate = self
        return cell
        
    }
    
    
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //
    //        if let category = categories?[indexPath.row] {
    //
    //            addedOrRemovedItem(titleText: "Successed Removed Category", messageText: category.name)
    //
    //            do {
    //
    //                try realm.write {
    //                    realm.delete(category)
    //                }
    //
    //            } catch {
    //
    //                print(error)
    //
    //            }
    //
    //
    //        }
    //        tableView.reloadData()
    //        //
    //    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
        
    }
    
    
    @IBAction func addCategoryButton(_ sender: UIBarButtonItem) {
        
        pop()
        
    }
    
    // MARK: - popFunction
    
    func pop() {
        
        var toDoField = UITextField()
        let alertController = UIAlertController(title: "Add New To Category", message: "", preferredStyle: .alert)
        
        // Create an OK Button
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            
            let newCategory = Category()
            newCategory.name = toDoField.text!
            // newCategory.color = UIColor.randomFlat.hexValue()
            self.save(category: newCategory)
            self.addedOrRemovedItem(titleText: "Successed Added Category", messageText: toDoField.text!)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // Add the OK Button to the Alert Controller
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        addAction.isEnabled = false
        
        // Add a text field to the alert controller
        alertController.addTextField { (textField) in
            textField.clearButtonMode = UITextField.ViewMode.whileEditing
            textField.placeholder = "Add New Category"
            textField.autocorrectionType = UITextAutocorrectionType.yes
            
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
    
    // MARK: - addedOrRemovedItemFunction
    
    func addedOrRemovedItem(titleText: String, messageText: String) {
        
        let addedOrRemovedItem = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        self.present(addedOrRemovedItem, animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - context Functions
    
    func save(category: Category) {
        
        do {
            
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            
            print(error)
            
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
}

extension CategoryViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            if let category = self.categories?[indexPath.row] {
                
                self.addedOrRemovedItem(titleText: "Successed Removed Category", messageText: category.name)
                
                do {
                    
                    try self.realm.write {
                        self.realm.delete(category)
                    }
                    
                } catch {
                    
                    print(error)
                    
                }
                
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
}
