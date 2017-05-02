//
//  UIExtensions.swift
//  PicFeed
//
//  Created by Luay Younus on 3/28/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resize(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    var path: URL {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Error getting documents directory")
        }
        return documentDirectory.appendingPathComponent("image")
    }
}

extension UIResponder {
    static var identifier : String {
        return String(describing: self)
    }
}
