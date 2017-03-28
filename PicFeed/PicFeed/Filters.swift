//
//  Filters.swift
//  PicFeed
//
//  Created by Luay Younus on 3/28/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit
enum FilterName: String {
    case vintage = "CIPhotoEffectTransfer"
    case blackAndWhite = "CIPhotoEffectMono"
}



//CIs are not thread-safe so we created the typealias
typealias FitlerCompletion = (UIImage) -> ()

class Filters {
    
    static var originalImage = UIImage() //statis var applys directly to the type
    
    
}

