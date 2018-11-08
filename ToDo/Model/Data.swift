//
//  Data.swift
//  ToDo
//
//  Created by Filip on 08/11/2018.
//  Copyright © 2018 Filip. All rights reserved.
//

import Foundation
import RealmSwift

//Object is subclass used to define realm model objects
class Data: Object {
    
    @objc dynamic var name: String = "" // declaration modifcation / allows monitor for change when app is running / we need to realm can monitoring
    @objc dynamic var age: Int = 0
    
}
