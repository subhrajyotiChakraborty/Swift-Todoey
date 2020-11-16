//
//  Category.swift
//  Todoey
//
//  Created by Subhrajyoti Chakraborty on 16/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var categoryName: String = ""
    
    let todoItems = List<TodoItem>()
}
