//
//  User+CoreDataClass.swift
//  
//
//  Created by Jack on 3/18/18.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    
    class func createUser(json: JSON) -> User? {
        
        if (json["id"].int64 == nil) {
            return nil
        }
        var user: User? = User.getUserWithID(json["id"].int64!)
        if user == nil {
            user = NSEntityDescription.insertNewObject(forEntityName: User.className, into: StorageController.getContext()) as? User
        }
        
        user?.user_id = json["id"].int64!

        user?.login = json["login"].string
        user?.avatar_url = json["avatar_url"].string
        user?.url = json["url"].string
        user?.gravatar_id = json["gravatar_id"].string
        user?.html_url = json["html_url"].string
        user?.followers_url = json["followers_url"].string
        user?.following_url = json["following_url"].string
        user?.gists_url = json["gists_url"].string
        user?.starred_url = json["starred_url"].string
        user?.subscriptions_url = json["subscriptions_url"].string
        user?.organizations_url = json["organizations_url"].string
        user?.repos_url = json["repos_url"].string
        user?.events_url = json["events_url"].string
        user?.received_events_url = json["received_events_url"].string
        user?.type = json["type"].string
        user?.site_admin = json["site_admin"].bool ?? false
        
        return user
    }
    
    class func getUserWithID(_ user_id: Int64) -> User? {
        
        let fetchRequest:NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user_id == \(user_id)")
        
        do {
            let searchResults = try StorageController.getContext().fetch(fetchRequest)
            if searchResults.count != 0 {
                return searchResults.first!
            }
        }
        catch {
            print("Error:\(error)")
        }
        
        return nil
    }
    
    class func getUsers() -> [User]? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "user_id", ascending: true)]
        
        do {
            let searchResults = try StorageController.getContext().fetch(fetchRequest)
            return searchResults
        }
        catch {
            print("Error:\(error)")
        }
        
        return nil
    }
    
    class func getUsersCount() -> Int {
        if let users = self.getUsers() {
            return users.count
        }
        return 0
    }
    
    class func getUserAtIndex(_ index: Int) -> User? {
        if let users = User.getUsers(), index < users.count {
            return users[index]
        } else {
            return nil
        }
    }

}
