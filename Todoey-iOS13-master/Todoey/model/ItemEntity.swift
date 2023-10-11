//
//  ItemEntity.swift
//  Todoey
//
//  Created by Funnmedia 2 on 24/08/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class ItemEntity: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    var parentCategory = LinkingObjects(fromType: ToDoListCategory.self, property: "itemss")
}
