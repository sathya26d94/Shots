//
//  ShotDetailViewController.swift
//  Shots
//
//  Created by sathiyamoorthy N on 19/05/19.
//  Copyright © 2019 SaTHYa. All rights reserved.
//

import UIKit

class ShotDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var resolutionLabel: UILabel!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textBoxLeadingPortraitConstraint: NSLayoutConstraint!
    
    
    var shotDetailViewModel: ShotDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.title = "Shots Detail"
    }
    func renderUI() {
        
        activityLoader.startAnimating()
        
        if let shotDetailViewModel = shotDetailViewModel {
            
            authorLabel.attributedText = shotDetailViewModel.author
            idLabel.attributedText = shotDetailViewModel.id
            resolutionLabel.attributedText = shotDetailViewModel.resolution
            
            imageView.kf.setImage(with: shotDetailViewModel.placeHolderImage, placeholder: nil, options: nil, progressBlock: nil) { (result) in
                self.imageView.kf.setImage(with: shotDetailViewModel.imageURL, placeholder: try? result.get().image, options: nil, progressBlock: nil) { (result) in
                    self.imageView.image = try? result.get().image
                    
                    self.activityLoader.stopAnimating()
                }
                
            }
            
        }
    }


}
