//
//  Validator.swift
//  Locations
//
//  Created by AT on 13/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class Validator: NSObject {

    func correctInputDecimal(text: String?) -> String? {
        if let text = text {
            let validated = text.regexMatches("-?\\d{0,3}(\\.\\d{0,100})?")
            return validated.first ?? "0"
        }
        return text
    }
    
    func correctDecimal(text: String?) -> String? {
        if let text = text {
            let validated = text.regexMatches("-?\\d+(\\.\\d{1,100})?")
            return validated.first ?? "0"
        }
        return text
    }
}
