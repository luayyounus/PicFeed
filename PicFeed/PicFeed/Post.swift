//
//  Post.swift
//  PicFeed
//
//  Created by Luay Younus on 3/28/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit
import CloudKit

class Post {
    let image: UIImage
    
    let date: Date?
    
    init(image: UIImage, date: Date?) {
        self.image = image
        self.date = date
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
        
        //GLOBAL function that takes JPEG and the quality of 0.7 (compression to 70%)
        guard let data = UIImageJPEGRepresentation(post.image, 0.7) else {throw PostError.writingImageToData} //will exit the func
        
        
        //it doesnt return a value so it's good to put it in do-catch
        
        do{
            try data.write(to: post.image.path) //write data to disk
            
            let asset = CKAsset(fileURL: post.image.path) //point the CKAsset to the disk(URL)
            
            let record = CKRecord(recordType: "Post") //creating a record on cloudkit
            
            record.setValue(asset,forKey:"image")
            
            return record
            
        } catch {
            throw PostError.writingDataToDisk
        }
        
    }
}

