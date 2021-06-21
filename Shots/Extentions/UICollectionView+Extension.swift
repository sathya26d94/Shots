//
//  UICollectionView+Extension.swift
//  Shots
//
//  Created by Sathiyamoorthy on 19/06/21.
//  Copyright © 2021 SaTHYa. All rights reserved.
//

import UIKit
import RxDataSources

typealias CollectionViewDataSource = RxCollectionViewSectionedReloadDataSource

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_: T.Type) {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). Check that the reuseIdentifier is set properly in your XIB/Storyboard and that you registered the cell beforehand")
        }
        return cell
    }
    
    func register<T: UICollectionReusableView>(supplementaryViewType: T.Type, ofKind elementKind: String) {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: nil)
        register(nib, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
    }
    
    final func dequeueReusableSupplementaryView<T: UICollectionReusableView>
    (ofKind elementKind: String, for indexPath: IndexPath, viewType: T.Type = T.self) -> T {
        let view = self.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: viewType.reuseIdentifier, for: indexPath)
        guard let typedView = view as? T else {
            fatalError("Failed to dequeue a supplementary view with identifier \(viewType.reuseIdentifier) matching type \(viewType.self). Check that the reuseIdentifier is set properly in your XIB/Storyboard and that you registered the supplementary view beforehand")
        }
        return typedView
    }
}
