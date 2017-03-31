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

//Image to Data
//Data to Location(pathway) on device's disk
//use the Location(pathway) to that data
enum PostError : Error {
    case writingImageToData
    case writingDataToDisk
}


//MARK: Handling post to CloudKit
extension Post {
    
    class func recordFor(post: Post) throws -> CKRecord? {
        
        //GLOBAL function that takes JPEG photos and the compress them to quality of 0.7 (or 70%)
        guard let data = UIImageJPEGRepresentation(post.image, 0.7) else {throw PostError.writingImageToData} //will throw and error (exit the func)
        
        
        //Since this function doesnt return a value, it's better to put it in a do-catch
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

