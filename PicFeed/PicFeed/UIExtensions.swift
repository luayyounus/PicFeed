//
//  UIExtensions.swift
//  PicFeed
//
//  Created by Luay Younus on 3/28/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resize(size: CGSize) -> UIImage? { //Core Graphic is a UIKit structure
        UIGraphicsBeginImageContext(size)
        
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        //capture an image of the draw and get rid of the draw
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //Stop the image context
        UIGraphicsEndImageContext()
        
        return resizedImage
        
    }
    
    var path: URL {
        
        // userDomainMask - user's home directory //give us the path for the requested user's home directory
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Error getting documents directory")
        }
        return documentDirectory.appendingPathComponent("image") //image is a subdirectory of documentDirectory
    }
    
}

extension UIResponder {
    static var identifier : String {
        return String(describing: self)
    }
}
