//
//  Item.swift
//  MyToDo
//
//  Created by IBM KSP on 1/8/18.
//  Copyright © 2018 KoppoluSaiPratap. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var itemName: String = ""
    @objc dynamic var state: Bool = false
    @objc dynamic var dateCreated: Date?
    let category = LinkingObjects(fromType: Category.self, property: "items")
    
}
