//
//  LoadManager.swift
//  NetcoTask
//
//  Created by Jack on 3/18/18.
//  Copyright © 2018 Jack. All rights reserved.
//

import Foundation

class LoadManager {
    
    static let sharedInstance = LoadManager()
    
    func getUsers(user_id: Int, completion: @escaping (_ success: Bool, _ result: Any?, _ message: String?) ->() ) {
        
        let url = ApiManager.sharedInstance.getURLForAction(.Users_list_GET)
        let parameters = ["since" : user_id] as [String : Any]
        
        NetworkManager.sharedInstance.get(url: url, parameters: parameters) { (success, responseJSON, message) in
            if success {
                // Parse data.
                var results = [User]()
                if responseJSON != nil {
                    results = self.parseUsers(json: responseJSON!, user_id: user_id)
                }
                completion(true, results, nil)
            } else {
                completion(false, nil, message)
            }
        }
    }
}

// MARK: - Private functions.

extension LoadManager {
    
    private func parseUsers(json: JSON, user_id: Int) -> [User] {
        if user_id == 0 {
            self.removeOldUsers()
        }
        var resultArray = [User]()
        for userJSON in json.arrayValue {
            if let user = User.createUser(json: userJSON) {
                resultArray.append(user)
            }
        }
        return resultArray
    }
    
    private func removeOldUsers() {
        
        let fetchRequest:NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let moc = StorageController.getContext()
            let searchResults = try moc.fetch(fetchRequest)
            for user in searchResults {
                moc.delete(user)
            }
            try moc.save()
        }
        catch {
            print("Error:\(error)")
        }
    }
}
