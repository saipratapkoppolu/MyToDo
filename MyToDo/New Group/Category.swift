//
//  Category.swift
//  MyToDo
//
//  Created by IBM KSP on 1/8/18.
//  Copyright © 2018 KoppoluSaiPratap. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var categoryName: String = ""
    let items = List<Item>()
}
