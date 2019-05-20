//
//  ShotCollectionViewCell.swift
//  Shots
//
//  Created by sathiyamoorthy N on 19/05/19.
//  Copyright © 2019 SaTHYa. All rights reserved.
//

import UIKit
import Kingfisher

class ShotCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    var shotData: ShotModel? {
        didSet {
            setupCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageView.layer.cornerRadius = 8
        self.imageView.layer.masksToBounds = true
        
    }
    
    func setupCell() {
        imageView.kf.cancelDownloadTask()
        authorLabel.text = shotData?.author
        let isDeviceiPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ? true : false
        
        let resolution = min(shotData?.width ?? 200, (isDeviceiPad ? 400 : 200))
                
        let imageUrl = Keys.BaseUrl.rawValue + Keys.imageApi.rawValue + "/\(shotData?.id ?? "1")/\(resolution)/\(resolution)"
        imageView.kf.setImage(with: URL.init(string: imageUrl))
        
    }

}
