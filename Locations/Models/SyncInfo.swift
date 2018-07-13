//
//  SyncInfo.swift
//  Locations
//
//  Created by AT on 11/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import RealmSwift

class SyncInfo: Object {
    override static func primaryKey() -> String {
        return "id"
    }
    
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var time: String = ""
}
