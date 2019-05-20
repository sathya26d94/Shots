//
//  ViewController.swift
//  Shots
//
//  Created by sathiyamoorthy N on 19/05/19.
//  Copyright © 2019 SaTHYa. All rights reserved.
//

import UIKit

class ShotsListController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let collectionViewCellReuseIdentifier = "ShotCollectionViewCell"
    private let collectionViewLoaderCellReuseIdentifier = "ActivityLoaderCollectionViewCell"
    private let collectionViewHeaderIdentifier = "ShotsHeaderCollectionViewCell"
    
    private var noOfCellsInRow = UIApplication.shared.statusBarOrientation.isLandscape ? 3 : 2
    
    let shotsListViewModel: ShotsListViewModel = ShotsListViewModel()
    
    lazy var wireFrame: ShotsListWireFrame = {
        return ShotsListWireFrame()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shotsListViewModel.delegate = self
        registerNibs()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
        
        let loaderNib = UINib(nibName: collectionViewLoaderCellReuseIdentifier, bundle: nil)
        collectionView.register(loaderNib, forCellWithReuseIdentifier: collectionViewLoaderCellReuseIdentifier)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shotsListViewModel.shotsList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == shotsListViewModel.shotsList.count {
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
        
        if indexPath.item == shotsListViewModel.shotsList.count {
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: collectionViewLoaderCellReuseIdentifier, for: indexPath) as? ActivityLoaderCollectionViewCell
            cell?.starLoader()
            guard let loaderCell = cell else {
                return UICollectionViewCell()
            }
            return loaderCell
        }
        
        
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
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
         if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewLoaderCellReuseIdentifier, for: indexPath) as? ActivityLoaderCollectionViewCell {
            
            cell.stopLoader()
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
        if indexPath.row != shotsListViewModel.shotsList.count {
            self.wireFrame.presentDetailInterface(fromController: self, shotData: shotsListViewModel.shotsList[indexPath.row])
        }
    }
        
}

