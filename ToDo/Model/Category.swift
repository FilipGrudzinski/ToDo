//
//  Category.swift
//  ToDo
//
//  Created by Filip on 08/11/2018.
//  Copyright © 2018 Filip. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>() //Forward category realationship
    
}
