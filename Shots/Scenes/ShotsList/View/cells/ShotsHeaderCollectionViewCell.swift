//
//  ShotsHeaderCollectionViewCell.swift
//  Shots
//
//  Created by sathiyamoorthy N on 19/05/19.
//  Copyright © 2019 SaTHYa. All rights reserved.
//

import UIKit

class ShotsHeaderCollectionViewCell: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setTitle(titleText: String) {
        titleLabel.text = titleText
    }
}
