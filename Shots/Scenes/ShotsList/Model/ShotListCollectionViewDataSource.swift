//
//  ShotListCollectionViewDataSource.swift
//  Shots
//
//  Created by Sathiyamoorthy on 19/06/21.
//  Copyright © 2021 SaTHYa. All rights reserved.
//

import UIKit
import RxDataSources

enum ShotListCollectionViewRowItems {
    /// Represents a cell with a collection view inside
    case ShotCollectionViewCellItem(shotData: ShotModel)
    /// Represents a cell with a loading indicator
    case ActivityLoaderCollectionViewCellItem
}

enum ShotListCollectionViewSections {
    case GridSection(items: [ShotListCollectionViewRowItems])
}

extension ShotListCollectionViewSections: SectionModelType {
    typealias Item = ShotListCollectionViewRowItems
    
    var header: String {
        switch self {
            case .GridSection:
                return "Shots"
        }
    }
    
    var items: [ShotListCollectionViewRowItems] {
        switch self {
            case .GridSection(items: let items):
                return items
        }
    }
    
    init(original: Self, items: [Self.Item]) {
        self = original
    }
}

struct ShotListCollectionViewDataSource {
    typealias DataSource = RxCollectionViewSectionedReloadDataSource
    
    func dataSource() -> DataSource<ShotListCollectionViewSections> {
        let dataSource = DataSource<ShotListCollectionViewSections>
            .init(configureCell: { dataSource, collectionView, indexPath, item -> UICollectionViewCell in
                
                switch dataSource[indexPath] {
                    case let .ShotCollectionViewCellItem(shotData):
                        let cell = collectionView
                            .dequeueReusableCell(
                                for: indexPath,
                                cellType: ShotCollectionViewCell.self
                            )
                        cell.shotData = shotData
                        return cell
                    case .ActivityLoaderCollectionViewCellItem:
                        let cell = collectionView
                            .dequeueReusableCell(
                                for: indexPath,
                                cellType: ActivityLoaderCollectionViewCell.self
                            )
                        return cell
                }
            })
        
        dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            let header = collectionView
                .dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    for: indexPath,
                    viewType: ShotsHeaderCollectionViewCell.self
                )
            header.setTitle(titleText: dataSource.sectionModels[indexPath.section].header)
            return header
        }
        
        return dataSource
    }
}
