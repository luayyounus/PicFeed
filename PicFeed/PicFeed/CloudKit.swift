//
//  CloudKit.swift
//  PicFeed
//
//  Created by Luay Younus on 3/27/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit
import CloudKit

typealias SuccessCompletion = (Bool)->() //for post
typealias PostsCompletion = ([Post]?)->() //for fetch


class CloudKit {
    static let shared = CloudKit()
    
    let container = CKContainer.default()
    
    var privateDatabase : CKDatabase {
        return self.container.privateCloudDatabase
    }
    
    func save(post: Post, completion: @escaping SuccessCompletion){ //@escaping goes over the network asynchonously
        
        do {
            if let record = try Post.recordFor(post: post){
                privateDatabase.save(record, completionHandler: { (record, error) in
                    
                    if error != nil {
                        completion(false)
                        return //so we dont get to the next record on line 35
                    }
                    
                    if let record = record {
                        print(record)
                        
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
            }
        } catch{
            print(error)
        }
    }
    
    func getPost(completion: @escaping PostsCompletion){
        
        let postQuery = CKQuery(recordType: "Post", predicate: NSPredicate(value: true))
        
        self.privateDatabase.perform(postQuery, inZoneWith: nil) { (records, error) in
         
            if error != nil {
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
            
            if let records = records {
                
                var posts = [Post]()
                
                for record in records {
                    
                    if let asset = record["image"] as? CKAsset{
                        
                        let path = asset.fileURL.path
                        
                        if let image = UIImage(contentsOfFile: path){
                            let newPost = Post(image: image)
                            
                            posts.append(newPost)
                        }
                    }
                }
                
                OperationQueue.main.addOperation {
                    completion(posts)
                }
                
            }
        }
        
    }
}
