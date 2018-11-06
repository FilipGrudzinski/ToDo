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

    var categoryArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryArray.append("Work")
        categoryArray.append("Home")
        categoryArray.append("School")
        

    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = categoryArray[indexPath.row]

        return cell
    }


    @IBAction func addCategoryButton(_ sender: UIBarButtonItem) {
        
        print("addCategoryButton Pressed")
        
    }
    
 
}
