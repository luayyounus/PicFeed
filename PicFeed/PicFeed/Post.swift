//
//  Post.swift
//  PicFeed
//
//  Created by Luay Younus on 3/28/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit

class Post {
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
}

//image to data
//data to location on device's disk then use the location(pathway to that data)
enum PostError : Error {
    case writingImageToData
    case writingDataToDisk
}


//handling post to CloudKit
extension Post {
    
    class func recordFor(post: Post) throws -> CKRecord? {
        
        //GLOBAL function that takes JPEG and the quality of 0.7
        guard let data = UIImageJPEGRepresentation(post.image, 0.7) else {throw PostError.writingImageToData} //will exit the func
        
        
    }
}

