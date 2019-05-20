//
//  ShotModel.swift
//  Shots
//
//  Created by sathiyamoorthy N on 19/05/19.
//  Copyright © 2019 SaTHYa. All rights reserved.
//

import Foundation

import Foundation

struct ShotModel: Codable {
    var id: String
    var author: String
    var imageUrl: String
    var width: Int
    var height: Int
    
    private enum CodingKeys : String, CodingKey {
        
        case id
        case author
        case width
        case height
        case imageUrl = "download_url"
        
    }
    
    static func getShotList(from responseObject : [Any]) -> [ShotModel]?{
        
        do {
            let responseJsonData = try JSONSerialization.data(withJSONObject: responseObject, options: .prettyPrinted)
            let decoder = JSONDecoder()
            let ShotList = try decoder.decode([ShotModel].self, from: responseJsonData)      
            return ShotList
        }catch {
            print(error)
        }
        
        return nil
        
    }
    
}
