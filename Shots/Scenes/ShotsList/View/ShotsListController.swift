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

    let shotsListViewModel: ShotsListViewModel = ShotsListViewModel()
    
    lazy var wireFrame: ShotsListWireFrame = {
        return ShotsListWireFrame()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shotsListViewModel.delegate = self
        registerNibs()
        shotsListViewModel.fetchShots()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        collectionView.collectionViewLayout.invalidateLayout()
        
    }
    
    
}

extension ShotsListController : ShotsListDelegate {
    
    func ShotsListDidChanged() {
        collectionView.reloadData()
    }
    
    func openDetailView(with data: ShotModel) {
        self.wireFrame.presentDetailInterface(fromController: self, shotData: data)
    }
    
}

extension ShotsListController {
    
    private func registerNibs() {
        
        let shotsNib = UINib(nibName: shotsListViewModel.collectionViewCellReuseIdentifier, bundle:nil)
        collectionView.register(shotsNib, forCellWithReuseIdentifier: shotsListViewModel.collectionViewCellReuseIdentifier)
        
        let headerNib = UINib(nibName: shotsListViewModel.collectionViewHeaderIdentifier, bundle: nil)
        self.collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: shotsListViewModel.collectionViewHeaderIdentifier)
        
        let loaderNib = UINib(nibName: shotsListViewModel.collectionViewLoaderCellReuseIdentifier, bundle: nil)
        collectionView.register(loaderNib, forCellWithReuseIdentifier: shotsListViewModel.collectionViewLoaderCellReuseIdentifier)
        
        collectionView.delegate = shotsListViewModel
        collectionView.dataSource = shotsListViewModel
    }
    
}

