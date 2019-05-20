//
//  ShotDetailViewModel.swift
//  Shots
//
//  Created by sathiyamoorthy N on 19/05/19.
//  Copyright © 2019 SaTHYa. All rights reserved.
//

import Foundation
import UIKit

protocol shotDetailViewModelType {
    
    var shotData: ShotModel {get}
    
    var author: NSAttributedString {get}
    
    var id: NSAttributedString {get}
    
    var resolution: NSAttributedString {get}
    
    var imageURL: URL {get}
    
    var placeHolderImage: URL {get}
    
    var imageAspectRatio: CGFloat {get}
    
}

class ShotDetailViewModel: shotDetailViewModelType   {
    
    var shotData: ShotModel
    
    var author: NSAttributedString {
        get {
            return getAuthorAttributedString()
        }
    }
    
    var resolution: NSAttributedString {
        get {
            return getResolutionAttributedString()
        }
    }
    
    var imageURL: URL {
        get {
            return URL.init(string: self.shotData.imageUrl)!
        }
    }
    
    var placeHolderImage: URL {
        get {
            return getPlaceHolderImageURL()
        }
    }
    
    var imageAspectRatio: CGFloat {
        get {
            return CGFloat(self.shotData.width/self.shotData.height)
        }
    }
    
    var id: NSAttributedString {
        get {
            return getIDAttributedString()
        }
    }
    
    
    init(shotData: ShotModel) {
        self.shotData = shotData
        
    }
    
    func getAuthorAttributedString() -> NSAttributedString {
        
        let authorString = NSMutableAttributedString()
        authorString.bold("Author").normal(" : ").normal(self.shotData.author)
        
        return authorString
    }
    
    func getIDAttributedString() -> NSAttributedString {
        
        let idString = NSMutableAttributedString()
        idString
            .bold("ID ")
            .normal(": " + self.shotData.id)
        return idString
        
    }
    
    func getResolutionAttributedString() -> NSAttributedString {
        let resolutionString = NSMutableAttributedString()
        resolutionString.bold("Resolution").normal(" : " + String(self.shotData.width)).normal("x").normal(String(self.shotData.height))
        return resolutionString
    }
    
    func getPlaceHolderImageURL() -> URL {
        let isDeviceiPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ? true : false
        let resolution = min(shotData.width, (isDeviceiPad ? 400 : 200))
        let imageUrl = Keys.BaseUrl.rawValue + Keys.imageApi.rawValue + "/\(shotData.id)/\(resolution)/\(resolution)"
        return URL.init(string: imageUrl)!
        
    }
    
}
