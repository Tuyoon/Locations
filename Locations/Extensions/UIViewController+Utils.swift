//
//  UIViewController+Utils.swift
//  Locations
//
//  Created by AT on 10/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class func controller<T: UIViewController>() -> T {
        let controller: T = self.controllerWithIdentifier(String(describing: T.self))
        return controller
    }
    
    class func initialController<T: UIViewController>() -> T {
        return self.storyboard().instantiateInitialViewController() as! T
    }
    
    class func controllerWithIdentifier<T: UIViewController>(_ identifier: String) -> T {
        let storyboard = self.storyboard()
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        
        return controller as! T
    }
    
    class func storyboard() -> UIStoryboard {
        let storyboard =  UIStoryboard(name: self.storyboardName(), bundle: nil)
        
        return storyboard
    }
    
    class func storyboardName() -> String {
        return "Main"
    }
}
