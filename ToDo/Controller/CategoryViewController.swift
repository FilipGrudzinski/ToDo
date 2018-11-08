//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Filip on 06/11/2018.
//  Copyright © 2018 Filip. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var alertTimer: Timer?
    var remainingTime = 0
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      loadCategory()
        

    }

    // MARK: - Table view data source methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }

    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = categoryArray[indexPath.row].name

        return cell
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        addedOrRemovedItem(titleText: "Successed Removed Category", messageText: categoryArray[indexPath.row].name!)
        
        context.delete(categoryArray[indexPath.row])
        
        categoryArray.remove(at: indexPath.row)
        
        saveCategory()
        
    }
    
      // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
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
            
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = toDoField.text!
           
            
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
            
            self.addedOrRemovedItem(titleText: "Successed Added Category", messageText: toDoField.text!)
            
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
    
    // MARK: - addedOrRemovedItemFunction
    
    func addedOrRemovedItem(titleText: String, messageText: String) {
        
        let addedOrRemovedItem = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        self.present(addedOrRemovedItem, animated: true, completion: nil)
        self.alertTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(ToDoListViewController.countDown), userInfo: nil, repeats: false)
        
        
    }
    
    
    @objc func countDown() {
        
        self.remainingTime += 1
        if (self.remainingTime > 0) {
            self.alertTimer?.invalidate()
            self.alertTimer = nil
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
     // MARK: - context Functions
    
    func saveCategory() {
        
        do {
            
            try context.save()
            
        } catch {
            
            print(error)
            
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategory() {
        
        let reguest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            
            categoryArray = try context.fetch(reguest)
            
        } catch {
            
            print(error)
            
        }
        
        tableView.reloadData()
        
    }
    
}
