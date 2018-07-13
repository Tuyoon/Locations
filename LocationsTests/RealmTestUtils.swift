//
//  RealmTestUtils.swift
//  LocationsTests
//
//  Created by AT on 10/07/2018.
//  Copyright © 2018. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Locations

class RealmTestUtils: NSObject {
    
    private static var url: URL?
    
    class func configureRealm(_ name: String) -> Bool {
        guard let url = RealmTestUtils.prepareRealmNamed(name) else {
            return false
        }
        self.url = url
        let configuration = RLMRealmConfiguration()
        configuration.fileURL = url
        RLMRealmConfiguration.setDefault(configuration)
        RLMRealm.default()
        
        return true
    }
    
    class func clear() {
        remove(url)
    }
    
    private class func prepareRealmNamed(_ name: String) -> URL? {
        let bundle = Bundle(for: RealmTestUtils.self)
        guard let fileUrl = bundle.url(forResource: name, withExtension: "realm") else {
            return nil
        }
        
        let directory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        let url = URL(fileURLWithPath: directory).appendingPathComponent("\(name).realm")
        
        remove(url)
        
        do {
            try FileManager.default.copyItem(at: fileUrl, to: url)
        } catch {
            return nil
        }
        return url
    }
    
    private class func remove(_ url: URL?) {
        guard let url = url else {
            return
        }
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: url.path) {
            try? fileManager.removeItem(at: url)
        }
        let lockUrl = url.appendingPathExtension("lock")
        if fileManager.fileExists(atPath: lockUrl.path) {
            try? fileManager.removeItem(at: lockUrl)
        }
        let managementUrl = url.appendingPathExtension("management")
        let isDirectory = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
        isDirectory[0] = true
        if fileManager.fileExists(atPath: managementUrl.path, isDirectory: isDirectory) {
            try? fileManager.removeItem(at: managementUrl)
        }
    }
}
