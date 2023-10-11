//
//  ToDoListCategory.swift
//  Todoey
//
//  Created by Funnmedia 2 on 24/08/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoListCategory: Object {
    @objc dynamic var name : String = ""
    
    let itemss = List<ItemEntity>()
}
