//
//  Data.swift
//  Todoey
//
//  Created by Subhrajyoti Chakraborty on 15/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
