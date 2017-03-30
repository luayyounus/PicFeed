//
//  CollectionReusableView.swift
//  PicFeed
//
//  Created by Luay Younus on 3/30/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit

class GalleryFooter: UICollectionReusableView {

    @IBOutlet weak var photosCounter: UILabel!
    
    let postsCounter = CloudKit.shared.globalPostsForFooter
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "GalleryFooter", for: indexPath as IndexPath)
        
        footerView.frame.size.height = 20

        func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            let size = CGSize(width: 400, height: 50)
            return size
        }
        
        func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            let size = CGSize(width: 400, height: 50)
            return size
        }
        
        self.photosCounter.text = "\(postsCounter) Photos"
        
        print(postsCounter)
        
        return footerView
    }
}
