//
//  ShotsListViewModel.swift
//  Shots
//
//  Created by sathiyamoorthy N on 19/05/19.
//  Copyright © 2019 SaTHYa. All rights reserved.
//

import Foundation
import UIKit

protocol ShotsListDelegate {
    func ShotsListtDidChanged()
}

protocol ShotsListViewModelType {
    var shotsList: [ShotModel] {get}
    
    var delegate: ShotsListDelegate? {get set }
    
    func fetchShots()
}

class ShotsListViewModel: ShotsListViewModelType   {
    
    var delegate: ShotsListDelegate?
    
    var shotsList : [ShotModel] = [] {//0 results by default
        didSet{
            DispatchQueue.main.async {
               self.delegate?.ShotsListtDidChanged() //notify
            }
        }
    }
    
    var pageNo = 1
    var pageLimt = 100
    var inProgress = false
    
    init() {
        fetchShots()
    }
    
    func fetchShots() {
        
        if inProgress {
            return
        }
        inProgress = true
        
        NetworkServices.shared.get(pathUrl: Keys.listApi.rawValue, parameters: ["page" : "\(pageNo)", "limit" : "\(pageLimt)"], successHandler: { (data) in
            
            if let data = data as? [Any], let shotsList = ShotModel.getShotList(from: data) {
                self.shotsList += shotsList
            }
            self.pageNo += 1
            self.inProgress = false
        }) { (error) in
            print(error)
            self.inProgress = false
        }
    }
    
    
}
