//
//  ViewController.swift
//  Shots
//
//  Created by sathiyamoorthy N on 19/05/19.
//  Copyright © 2019 SaTHYa. All rights reserved.
//

import UIKit
import RxSwift

class ShotsListController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let shotsListViewModel: ShotsListViewModelProtocol = ShotsListViewModel()
    private lazy var wireFrame: ShotsListWireFrame = {
        return ShotsListWireFrame()
    }()
    private var noOfCellsInRow: CGFloat {
        UIApplication.shared.statusBarOrientation.isLandscape ? 3.0 : 2.0
    }
    
    //MARK: - Constants
    private let indicatorCellHeight: CGFloat = 100.0
    private let headerCellHeight: CGFloat = 48.0
    private let shotsCellHeightConstant: CGFloat = 28.0

    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        addCollectionViewBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    //MARK: - Bindings
    private func addCollectionViewBindings() {
        shotsListViewModel.shotModelItems
            .bind(to: collectionView.rx.items(dataSource: shotsListViewModel.shotModelDataSource.dataSource()))
            .disposed(by: disposeBag)
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx
            .willDisplayCell
            .subscribe(onNext: { [weak self] cell, indexPath in
                if let cell = cell as? ActivityLoaderCollectionViewCell {
                    cell.starLoader()
                    self?.shotsListViewModel.fetchNextPage()
                }
            }).disposed(by: disposeBag)
        
        collectionView.rx
            .didEndDisplayingCell
            .subscribe(onNext: { cell, indexPath in
                if let cell = cell as? ActivityLoaderCollectionViewCell {
                    cell.stopLoader()
                }
            }).disposed(by: disposeBag)
    }
    
    private func registerNibs() {
        collectionView.register(ShotCollectionViewCell.self)
        collectionView.register(ActivityLoaderCollectionViewCell.self)
        collectionView.register(
            supplementaryViewType: ShotsHeaderCollectionViewCell.self,
            ofKind: UICollectionView.elementKindSectionHeader
        )                
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ShotsListController: UICollectionViewDelegateFlowLayout {
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                        
            let window = UIApplication.shared.keyWindow
            guard let leftSafeAreaInset = (window?.safeAreaInsets.left),
                  let rightSafeAreaInset = (window?.safeAreaInsets.right),
                  let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
            else { return .zero }
            
            let lastRowIndex = max(0, collectionView.numberOfItems(inSection: indexPath.section) - 1)
            //Activity Indicator View Cell
            if lastRowIndex == indexPath.row {
                let viewPadding = flowLayout.sectionInset.left + flowLayout.sectionInset.right
                return CGSize(width: collectionView.bounds.width - viewPadding, height: indicatorCellHeight)
            } else { //Shots View Cell
                let totalHorizontalEmptySpaces = flowLayout.sectionInset.left
                    + flowLayout.sectionInset.right
                    + (flowLayout.minimumInteritemSpacing * (noOfCellsInRow - 1))
                    + leftSafeAreaInset
                    + rightSafeAreaInset
                
                let width = (UIScreen.main.bounds.width - totalHorizontalEmptySpaces) / noOfCellsInRow
                let height = width + shotsCellHeightConstant
                return CGSize(width: width, height: height)
            }
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: headerCellHeight)
        }
    
}
