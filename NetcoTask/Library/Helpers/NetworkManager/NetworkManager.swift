//
//  NetworkManager.swift
//  NetcoTask
//
//  Created by Jack on 3/18/18.
//  Copyright © 2018 Jack. All rights reserved.
//

import Foundation
import ReachabilitySwift

class NetworkManager: NSObject {
    
    static let sharedInstance = NetworkManager()
    
    private let headers: HTTPHeaders = [
        "Accept" : "application/json"
    ]
    
    func get( url: String, parameters: Parameters, completion: @escaping (_ success: Bool, _ result: JSON?, _ errorMessage: String?)->() ) {
        
        let allHeaders = headers
        
        Alamofire.request(url, method: .get, parameters: parameters, headers: allHeaders).validate().responseJSON {
            responseJSON in
            
            switch responseJSON.result {
            case .success(let value):
                completion(true, JSON(value), nil)
            case .failure:
                let message = self.parseError(responseJSON)
                completion(false, nil, message)
            }
        }
    }
    
    func post(url: String, parameters: Parameters, authourization: Bool = false, completion: @escaping (_ success: Bool, _ result: JSON?, _ errorMessage: String?)->()) {
        
        let allHeaders = headers
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: allHeaders).validate().responseJSON {
            responseJSON in
            
            switch responseJSON.result {
            case .success(let value):
                completion(true, JSON(value), nil)
            case .failure:
                let message = self.parseError(responseJSON)
                completion(false, nil, message)
            }
        }
    }
    
    func delete(url: String, parameters: Parameters, authourization: Bool = false, completion: @escaping (_ success: Bool, _ result: JSON?, _ errorMessage: String?)->()) {
        
        let allHeaders = headers
        
        Alamofire.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: allHeaders).validate().responseJSON {
            responseJSON in
            
            switch responseJSON.result {
            case .success(let value):
                completion(true, JSON(value), nil)
            case .failure:
                let message = self.parseError(responseJSON)
                completion(false, nil, message)
            }
        }
    }
    
    func patch(url: String, parameters: Parameters, authourization: Bool = false, completion: @escaping (_ success: Bool, _ result: JSON?, _ errorMessage: String?)->()) {
        
        let allHeaders = headers

        Alamofire.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: allHeaders).validate().responseJSON {
            responseJSON in
            
            switch responseJSON.result {
            case .success(let value):
                completion(true, JSON(value), nil)
            case .failure:
                let message = self.parseError(responseJSON)
                completion(false, nil, message)
            }
        }
    }
    
    // MARK: - Private methods.
    
    private func parseError(_ errorJSON: DataResponse<Any>) -> String? {
        // Empty request.
        if errorJSON.response == nil {
            return nil
        }
        let statusCode = errorJSON.response!.statusCode as Int

        // Cancel request.
        if statusCode == -999 {
            return nil
        }
        if errorJSON.data == nil {
            return NSLocalizedString("Неизвестная ошибка", comment: "")
        }
        let dataJSON = JSON(errorJSON.data!)
        let message: String? = dataJSON["message"].string ?? nil
        
        return message
    }
    
}

