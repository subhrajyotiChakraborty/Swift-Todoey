//
//  TodoItem.swift
//  Todoey
//
//  Created by Subhrajyoti Chakraborty on 16/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    @objc dynamic var isChecked: Bool = false
    @objc dynamic var name: String = ""
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "todoItems")
}
