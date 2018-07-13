
//  LocationsManager.swift
//  Locations
//
//  Created by AT on 06/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

class LocationsManager: NSObject {
    
    static func locations() -> Results<Location> {
        let realm = try! Realm()
        return realm.objects(Location.self)
    }
    
    static func observe(_ block: @escaping (RealmCollectionChange<Results<Location>>) -> Void) -> NotificationToken {
        let realm = try! Realm()
        return realm.objects(Location.self).observe(block)
    }
    
    static func loadLocations() {
        API.loadLocations(onSuccess: { (response) in
            parseAndSaveLocations(dictionary: response)
        }) { (error) in
            
        }
    }
    
    private static func parseAndSaveLocations(dictionary: [String: AnyObject]) {
        guard let locations = dictionary["locations"] as? [[String: AnyObject]], let updateTime = dictionary["updated"] as? String else {
            return
        }
        
        let realm = try! Realm()
        let syncInfo = realm.objects(SyncInfo.self).first ?? SyncInfo()
        guard syncInfo.time != updateTime else {
            return
        }
        
        realm.beginWrite()
        locations.forEach { (dictionary) in
            let location = Location(dictionary: dictionary)
            if let existingLocation = realm.object(ofType: Location.self, forPrimaryKey: location.title) {
                location.notes = existingLocation.notes
            }
            realm.add(location, update: true)
        }
        
        syncInfo.time = updateTime
        realm.add(syncInfo, update: true)
        
        try? realm.commitWrite()
    }
    
    static func saveLocation(model: LocationModel) {
        let realm = try! Realm()
        realm.beginWrite()
        
        let location = Location()
        location.id = model.id ?? UUID().uuidString
        location.title = model.title
        location.latitude = model.latitude
        location.longitude = model.longitude
        location.notes = model.notes
        
        realm.add(location, update: true)
        try? realm.commitWrite()
    }
}
