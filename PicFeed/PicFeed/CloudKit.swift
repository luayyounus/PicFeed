//
//  CloudKit.swift
//  PicFeed
//
//  Created by Luay Younus on 3/27/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import Foundation
import CloudKit

typealias PostCompletion = (Bool)->()


class CloudKit {
    static let shared = CloudKit()
    
    let container = CKContainer.default()
    
    var privateDatabase : CKDatabase {
        return self.container.privateCloudDatabase //we can take out the self because its implicit
    }
    
    func save(post: Post, completion: @escaping PostCompletion){ //@escaping goes over the network asynchonously
        
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
}
