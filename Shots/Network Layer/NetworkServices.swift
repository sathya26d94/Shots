//
//  NetworkServices.swift
//  Shots
//
//  Created by sathiyamoorthy N on 19/05/19.
//  Copyright © 2019 SaTHYa. All rights reserved.
//

import Foundation

typealias NetworkCompletionHandler = (Data?, URLResponse?, Error?) -> Void
public typealias ErrorHandler = (String) -> Void

open class NetworkServices {
    let genericError = "Oops! Something went wrong. Please try again later"
    
    static let shared = NetworkServices()
    
    private init() {
    }
    
    open func get(pathUrl: String,
                                parameters: [String: String] = [:],
                                successHandler: @escaping (Any) -> Void,
                                errorHandler: @escaping ErrorHandler) {
        
        let completionHandler: NetworkCompletionHandler = { (data, urlResponse, error) in
            if let error = error {
                print(error.localizedDescription)
                errorHandler(self.genericError)
                return
            }
            
            if self.isSuccessCode(urlResponse) {
                guard let data = data else {
                    return errorHandler(self.genericError)
                }
                if let responseObject =  try? JSONSerialization.jsonObject(with:
                    data, options: []) {
                    successHandler(responseObject)
                    return
                }
            }
            errorHandler(self.genericError)
        }
        
        let completeUrl = Keys.BaseUrl.rawValue + pathUrl + buildQueryString(fromDictionary: parameters)
        guard let url = URL(string: completeUrl) else {
            return errorHandler("Unable to create URL from given string")
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    
    
    private func isSuccessCode(_ statusCode: Int) -> Bool {
        return statusCode >= 200 && statusCode < 300
    }
    
    private func isSuccessCode(_ response: URLResponse?) -> Bool {
        guard let urlResponse = response as? HTTPURLResponse else {
            return false
        }
        return isSuccessCode(urlResponse.statusCode)
    }
    
    func buildQueryString(fromDictionary parameters: [String:String]) -> String {
        var urlVars:[String] = []
        
        for (k,value) in parameters {
            if let encodedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                urlVars.append(k + "=" + encodedValue)
            }
        }
        
        return urlVars.isEmpty ? "" : "?" + urlVars.joined(separator: "&")
    }
}

