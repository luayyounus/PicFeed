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
    
    @IBOutlet weak var imageDateCreated: UILabel!    
    
    var post: Post! {
        didSet {
            self.imageView.image = post.image
            self.imageDateCreated.text = DateFormatter.localizedString(from: post.date!, dateStyle: .short, timeStyle: .short)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
    }
    
}
