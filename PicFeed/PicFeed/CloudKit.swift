//
//  CloudKit.swift
//  PicFeed
//
//  Created by Luay Younus on 3/27/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import Foundation
import CloudKit

class CloudKit {
    static let shared = CloudKit()
    
    let container = CKContainer.default()
    
    var privateDatabase : CKDatabase {
        return self.container.privateCloudDatabase //we can take out the self because its implicit
    }
}
