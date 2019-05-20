//
//  ActivityLoaderCollectionViewCell.swift
//  Shots
//
//  Created by sathiyamoorthy N on 20/05/19.
//  Copyright © 2019 SaTHYa. All rights reserved.
//

import UIKit

class ActivityLoaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func starLoader() {
        loader.startAnimating()
    }
    
    func stopLoader() {
        loader.stopAnimating()
    }

}
