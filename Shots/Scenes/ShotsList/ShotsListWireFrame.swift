//
//  ShotsListWireFrame.swift
//  Shots
//
//  Created by sathiyamoorthy N on 19/05/19.
//  Copyright © 2019 SaTHYa. All rights reserved.
//

import Foundation
import UIKit

class ShotsListWireFrame {
    
    var shotDetailViewController: ShotDetailViewController?
    
    func presentDetailInterface(fromController: UIViewController, shotData: ShotModel){
        
        shotDetailViewController = ShotDetailViewController()
        shotDetailViewController?.shotDetailViewModel = ShotDetailViewModel.init(shotData: shotData)
        fromController.navigationController?.pushViewController(shotDetailViewController!, animated: true)
        
    }
}
