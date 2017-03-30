//
//  FilterCell.swift
//  PicFeed
//
//  Created by Luay Younus on 3/30/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var filterName: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
        self.filterName.text = nil
    }
}
