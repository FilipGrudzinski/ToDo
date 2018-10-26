//
//  ViewController.swift
//  ToDo
//
//  Created by Filip on 26/10/2018.
//  Copyright © 2018 Filip. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

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

}

