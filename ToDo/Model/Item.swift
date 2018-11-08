//
//  Item.swift
//  ToDo
//
//  Created by Filip on 08/11/2018.
//  Copyright © 2018 Filip. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")  //Reverse category realationship
    
}
