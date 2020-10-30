//
//  TodoItem.swift
//  Todoey
//
//  Created by Subhrajyoti Chakraborty on 17/06/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation


struct TodoItem: Codable {
    var name: String
    var isChecked: Bool
    
    init(name: String, isChecked: Bool = false) {
        self.name = name
        self.isChecked = isChecked
    }
}
