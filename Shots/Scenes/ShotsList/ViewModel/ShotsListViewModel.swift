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
    func ShotsListDidChanged()
    func openDetailView(with data: ShotModel)
}

protocol ShotsListViewModelType {
    var shotsList: [ShotModel] {get}
    
    var delegate: ShotsListDelegate? {get set }
    
    func fetchShots()
}

class ShotsListViewModel: NSObject, ShotsListViewModelType   {
    
    var delegate: ShotsListDelegate?
    
    var shotsList : [ShotModel] = [] {//0 results by default
        didSet{
            DispatchQueue.main.async {
               self.delegate?.ShotsListDidChanged() //notify
            }
        }
    }
    
    var pageNo = 1
    var pageLimt = 100
    var inProgress = false
    var noOfCellsInRow = UIApplication.shared.statusBarOrientation.isLandscape ? 3 : 2
    let collectionViewCellReuseIdentifier = "ShotCollectionViewCell"
    let collectionViewLoaderCellReuseIdentifier = "ActivityLoaderCollectionViewCell"
    let collectionViewHeaderIdentifier = "ShotsHeaderCollectionViewCell"
    
    
    override init() {
        
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


//MARK : collectionView datasouce delegates

extension ShotsListViewModel: UICollectionViewDataSource ,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shotsList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == shotsList.count {
            return CGSize(width: UIScreen.main.bounds.width, height: 50)
        }
        
        noOfCellsInRow = UIApplication.shared.statusBarOrientation.isLandscape ? 3 : 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let window = UIApplication.shared.keyWindow
        let leftPadding = (window?.safeAreaInsets.left)!
        let rightPadding = (window?.safeAreaInsets.right)!
        
        
        let width = Int(((UIScreen.main.bounds.width - leftPadding - rightPadding) - totalSpace) / CGFloat(noOfCellsInRow))
        let height = width + 27
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == shotsList.count {
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: collectionViewLoaderCellReuseIdentifier, for: indexPath) as? ActivityLoaderCollectionViewCell
            cell?.starLoader()
            guard let loaderCell = cell else {
                return UICollectionViewCell()
            }
            return loaderCell
        }
        
        
        let showDetail = shotsList[indexPath.row]
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: collectionViewCellReuseIdentifier, for: indexPath) as? ShotCollectionViewCell
        
        guard let showsCell = cell else {
            return UICollectionViewCell()
        }
        showsCell.shotData = showDetail
        return showsCell
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == shotsList.count - 1 {
            
            fetchShots()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewLoaderCellReuseIdentifier, for: indexPath) as? ActivityLoaderCollectionViewCell {
            
            cell.stopLoader()
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionViewHeaderIdentifier, for: indexPath) as? ShotsHeaderCollectionViewCell {
                return headerView
            }
            
        default:
            assert(false, "Unexpected element kind")
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != shotsList.count {
            delegate?.openDetailView(with: shotsList[indexPath.row])
        }
    }
    
}

