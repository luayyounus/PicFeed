//
//  Filters.swift
//  PicFeed
//
//  Created by Luay Younus on 3/28/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit
import CoreImage

enum FilterName: String {
    case vintage = "CIPhotoEffectTransfer"
    case blackAndWhite = "CIPhotoEffectMono"
    case chrome = "CIPhotoEffectChrome"
    case colorSpace = "CIColorCubeWithColorSpace"
    case dark = "CIColorPolynomial"
}

typealias FilterCompletion = (UIImage?) -> ()

class Filters {
    
    static var originalImage : UIImage?

    let filterNamesArray = ["Vintage","Black & White","Chrome","Color Space","Dark"]

    var ciContext : CIContext
    
    static let shared = Filters()
    
    private init() {
        let options = [kCIContextWorkingColorSpace: NSNull()]
        guard let eaglContext = EAGLContext(api: .openGLES2) else {fatalError("Failed to create EAGLContext.")}
        self.ciContext = CIContext(eaglContext: eaglContext, options: options)
    }
    
    class func filter(name: FilterName, image: UIImage, completion: @escaping FilterCompletion){
        OperationQueue().addOperation {
        guard let filter = CIFilter(name: name.rawValue) else {fatalError("Fail to Create CIFilter")}
        
        let coreImage = CIImage(image: image)
        filter.setValue(coreImage, forKey: kCIInputImageKey)
        
        guard let outputImage = filter.outputImage else { fatalError("Fail to get output image from Filter.")}
        
            if let cgImage = shared.ciContext.createCGImage(outputImage, from: outputImage.extent){
                
                let orientation = image.imageOrientation
                let scaledImage = image.scale
                let finalImage = UIImage(cgImage: cgImage, scale: scaledImage, orientation: orientation)
                
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

