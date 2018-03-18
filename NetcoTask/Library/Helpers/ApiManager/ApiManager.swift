//
//  ApiManager.swift
//  NetcoTask
//
//  Created by Jack on 3/18/18.
//  Copyright © 2018 Jack. All rights reserved.
//

import Foundation

class ApiManager {
    
    static let sharedInstance = ApiManager()
    
    enum ApiManagerAction {
        case Users_list_GET
    }
    
    func getURLForAction(_ type: ApiManagerAction) -> String {
       
        let action: String
        
        switch type {
        case .Users_list_GET:
            action = "/users"
        }
        
        let url = String("\(ApiManager.getBasicURL())\(action)")
        return url
        
    }
    
    class func getBasicURL() -> String {
        return "https://api.github.com"
    }
}
