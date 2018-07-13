//
//  Location.swift
//  Locations
//
//  Created by AT on 05/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import CoreLocation

class Location: Object {
    override static func primaryKey() -> String {
        return "id"
    }
    
    @objc dynamic var id: String?
    @objc dynamic var title: String = ""
    @objc dynamic var notes: String = ""
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var latitudeString: String {
        return "\(latitude)"
    }
    
    var longitudeString: String {
        return "\(longitude)"
    }
    
    required init(dictionary: [String: AnyObject]) {
        super.init()
        
        if let title = dictionary["name"] as? String {
            self.id = title
            self.title = title
        }
        if let latitude = dictionary["lat"] as? Double {
            self.latitude = latitude
        }
        if let longitude = dictionary["lng"] as? Double {
            self.longitude = longitude
        }
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}
