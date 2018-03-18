//
//  Constants.swift
//  NetcoTask
//
//  Created by Jack on 3/18/18.
//  Copyright © 2018 Jack. All rights reserved.
//

import Foundation

class Constants {
    
    // Alerts.
    
    class func showAlert(title: String, message: String) {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alertVC.view.tintColor = UIColor.black
        alertVC.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { action -> Void in
        }))
        let topVC = UIApplication.topViewController()
        if topVC is UIAlertController {
            return
        }
        topVC?.present(alertVC, animated: true, completion: nil)
    }
    
}
