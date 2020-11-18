//
//  Category.swift
//  Todoey
//
//  Created by Subhrajyoti Chakraborty on 16/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class Category: Object {
    @objc dynamic var categoryName: String = ""
    @objc dynamic var cellBackgroundColor: String = UIColor.randomFlat().hexValue()
    
    let todoItems = List<TodoItem>()
}
