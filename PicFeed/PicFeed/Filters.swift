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
    case chrome = "CIPhotoEffectChrome"
    case colorSpace = "CIColorCubeWithColorSpace"
    case darkAndSexy = "CIColorPolynomial"
}



//CIs are not thread-safe so we created the typealias
typealias FilterCompletion = (UIImage?) -> ()

class Filters {
    
    let ciContext = CIContext()
    
    static let sharedFilters: Filters = {
       let instance = Filters()
        //GPU Context
        let options = [kCIContextWorkingColorSpace: NSNull()]
        
        guard let eaglContext = EAGLContext(api: .openGLES2) else {fatalError("Failed to create EAGLContext.")}
        
        let ciContext = CIContext(eaglContext: eaglContext, options: options)
        
        return instance
    }()
    
    
    static var originalImage = UIImage() //static var applys directly to the type
    
    class func filter(name: FilterName, image: UIImage, completion: @escaping FilterCompletion){
        
        OperationQueue().addOperation {
            
        guard let filter = CIFilter(name: name.rawValue) else {fatalError("Fail to Create CIFilter")}
        
        let coreImage = CIImage(image: image)
        filter.setValue(coreImage, forKey: kCIInputImageKey)
        
        
        
        // Get the final image from using the GPU
        guard let outputImage = filter.outputImage else { fatalError("Fail to get output image from Filter.")}
        
            if let cgImage = sharedFilters.ciContext.createCGImage(outputImage, from: outputImage.extent){ //extent takes the whole image and draw it exactly on the cloud
                
                let finalImage = UIImage(cgImage: cgImage)
                
                OperationQueue.main.addOperation {
                    completion(finalImage)
                }
            } else {
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
        }
        
    }
}

