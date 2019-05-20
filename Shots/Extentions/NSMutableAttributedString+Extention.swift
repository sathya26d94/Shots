//
//  NSMutableAttributedString+Extention.swift
//  EKart
//
//  Created by sathiyamoorthy N on 24/11/18.
//  Copyright © 2018 sathiyamoorthy N. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        
        let isDeviceiPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ? true : false
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "AvenirNext-Bold", size: isDeviceiPad ? 24 : 16)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        
        let isDeviceiPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ? true : false
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "AvenirNext-Regular", size: isDeviceiPad ? 24 : 16)!]
        let normal = NSMutableAttributedString(string:text, attributes: attrs)
        append(normal)
        
        return self
    }
}
