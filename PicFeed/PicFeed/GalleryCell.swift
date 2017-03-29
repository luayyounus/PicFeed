//
//  GalleryCell.swift
//  PicFeed
//
//  Created by Luay Younus on 3/29/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    var post: Post! {
        didSet {
            self.imageView.image = post.image
        }
    }
    
    
    //every Collection has this so we get rid of the flickering between changing images on screen
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil //when we go through the process we dont see whats happening
    }
    
}
