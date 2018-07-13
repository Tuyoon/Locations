//
//  API.swift
//  Locations
//
//  Created by AT on 06/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import Alamofire

typealias APISuccessBlock = (_ response: [String:AnyObject]) -> Void
typealias APIErrorBlock = (_ error: String?) -> Void

let kLocationsUrl: String = "http://bit.ly/test-locations"

class API: NSObject {
    
    static func loadLocations(onSuccess: APISuccessBlock?, onError: APIErrorBlock?) {
        var request = URLRequest(url: URL(string: kLocationsUrl)!)
        request.httpMethod = "GET"
        executeRequest(request: request, onSuccess: onSuccess, onError: onError)
    }
    
    private static func executeRequest(request: URLRequest, onSuccess: APISuccessBlock?, onError: APIErrorBlock?) {
        Alamofire.SessionManager.default.request(request).responseData { (response) in
            switch response.result {
            case .failure(let error):
                onError?("\(error)")
                return
            default:
                break
            }

            guard let data = response.data, let responseDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject] else {
                onError?(nil)
                return
            }

            onSuccess?(responseDictionary!)
        }
    }
}
