//
//  ShotsListViewModel.swift
//  Shots
//
//  Created by sathiyamoorthy N on 19/05/19.
//  Copyright © 2019 SaTHYa. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import RxDataSources

protocol ShotsListViewModelProtocol {
    var shotModelItems: BehaviorRelay<[ShotListCollectionViewSections]> { get }
    var shotModelDataSource: ShotListCollectionViewDataSource { get }
    
    func fetchNextPage()
}

class ShotsListViewModel: ShotsListViewModelProtocol  {
    
    //MARK: - ShotsListViewModelProtocol
    var shotModelItems = BehaviorRelay<[ShotListCollectionViewSections]>(value: [])
    var shotModelDataSource: ShotListCollectionViewDataSource = ShotListCollectionViewDataSource()
    
    //MARK: - Private Properties
    private var pageNo = 1
    private var inProgress = false
    
    //MARK: - Constants
    private let pageLimt = 10
    
    //MARK: - Initializer
    init() {
        fetchShots()
    }
    
    //MARK: - Public methods
    func fetchNextPage() {
        fetchShots()
    }
    
    //MARK: - Private methods
    private func fetchShots() {
        
        if inProgress {
            return
        }
        inProgress = true
        
        NetworkServices.shared.get(pathUrl: Keys.listApi.rawValue, parameters: ["page" : "\(pageNo)", "limit" : "\(pageLimt)"], successHandler: { [weak self] (data) in
            guard let self = self else { return }
            
            if let data = data as? [Any], let shotsList = ShotModel.getShotList(from: data) {
                var tableViewItems = shotsList.map { shotModel in
                    ShotListCollectionViewRowItems.ShotCollectionViewCellItem(shotData: shotModel)
                }
                
                var previousShotModelItems: [ShotListCollectionViewRowItems] = []
                
                if !self.shotModelItems.value.isEmpty {
                    previousShotModelItems = self.shotModelItems.value[0].items.dropLast()
                }
                
                tableViewItems.append(ShotListCollectionViewRowItems.ActivityLoaderCollectionViewCellItem)
                
                let sectionItem = [
                    ShotListCollectionViewSections.GridSection(items:previousShotModelItems + tableViewItems)
                ]
                self.shotModelItems.accept(sectionItem)
            }
            self.pageNo += 1
            self.inProgress = false
        }) { (error) in
            print(error)
            self.inProgress = false
        }
    }
    
}
