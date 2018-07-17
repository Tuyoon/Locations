//
//  String+Utils.swift
//  Locations
//
//  Created by AT on 06/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

extension String {
    func double() -> Double? {
        return (self as NSString).doubleValue
    }
    
    func regexMatches(_ regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let results = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            return results.map { String(self[Range($0.range, in: self)!])}
        } catch {
            return []
        }
    }
}
