//
//  ViewController.swift
//  Shots
//
//  Created by sathiyamoorthy N on 18/05/19.
//  Copyright © 2019 SaTHYa. All rights reserved.
//

import UIKit

class ShotsListController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var collectionViewCellReuseIdentifier = "ShotCollectionViewCell"
    private let collectionViewHeaderIdentifier = "ShotsHeaderCollectionViewCell"

    private var noOfCellsInRow = UIApplication.shared.statusBarOrientation.isLandscape ? 3 : 2
    
    let shotsListViewModel: ShotsListViewModel = ShotsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shotsListViewModel.delegate = self
        registerNibs()
        
    }
    
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        handleRotation(newOrientation: toInterfaceOrientation)
        
    }


}

extension ShotsListController : ShotsListDelegate {
    
    func ShotsListtDidChanged() {
        collectionView.reloadData()
    }
    
}

extension ShotsListController: UICollectionViewDataSource ,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private func registerNibs(){
        
        let shotsNib = UINib(nibName: collectionViewCellReuseIdentifier, bundle:nil)
        collectionView.register(shotsNib, forCellWithReuseIdentifier: collectionViewCellReuseIdentifier)
                
        let headerNib = UINib(nibName: collectionViewHeaderIdentifier, bundle: nil)
        self.collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionViewHeaderIdentifier)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shotsListViewModel.shotsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        noOfCellsInRow = UIApplication.shared.statusBarOrientation.isLandscape ? 3 : 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let width = Int((UIScreen.main.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        let height = width + 27
        return CGSize(width: width, height: height)
        
    }    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let showDetail = shotsListViewModel.shotsList[indexPath.row]
        
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: collectionViewCellReuseIdentifier, for: indexPath) as? ShotCollectionViewCell
        
        guard let showsCell = cell else {
            return UICollectionViewCell()
        }
        showsCell.shotData = showDetail
        return showsCell
        

    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == shotsListViewModel.shotsList.count - 1 {
            
            shotsListViewModel.fetchShots()
        }
        
        
    }
    
    
    func handleRotation(newOrientation:UIInterfaceOrientation) {
        
        if newOrientation == .landscapeRight || newOrientation == .landscapeLeft {
            noOfCellsInRow = 3
        }else {
            noOfCellsInRow = 2
        }
        
        collectionView.collectionViewLayout.invalidateLayout()
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionViewHeaderIdentifier, for: indexPath) as? ShotsHeaderCollectionViewCell {
                
//                headerView.titleLabel.text = "Shots"
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
    
//    func showSkeleton() {
//        let skeletonLayout = UICollectionViewFlowLayout()
//        skeletonLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
//        skeletonLayout.itemSize = CGSize(width: 375, height: 280)
//
//        var skeletonFrame = self.frame
//        if let channelController = self.parentViewController as? ChannelDetailViewController {
//            skeletonFrame.origin.y = skeletonFrame.origin.y + channelController.channelDetailView.frame.height
//        }
//        skeletonCollectionView = SkeletonCollectionView(frame: skeletonFrame, collectionViewLayout: skeletonLayout)
//        skeletonLayout.invalidateLayout()
//        if let _ = self.parentViewController as? ChannelDetailViewController {
//            skeletonCollectionView?.source = TelemetryEvents.channelPage.rawValue
//        }
//        // skeletonCollectionView?.contentInset = self.contentInset
//        skeletonCollectionView?.showSkeleton(contentType: self.contentType)
//        if let _ = skeletonCollectionView {
//            self.parentViewController.view.addSubview(skeletonCollectionView!)
//        }
//    }
//
//    func removeSkeleton() {
//        self.skeletonCollectionView?.alpha = 1.0
//        UIView.animate(withDuration: 0.5, animations: {
//            self.skeletonCollectionView?.alpha = 0.0
//        }) { (finished) in
//            self.skeletonCollectionView?.removeFromSuperview()
//        }
//    }
//
//    func updateSkeletonViewFrame(frame: CGRect) {
//        skeletonCollectionView?.frame = frame
//    }
}
