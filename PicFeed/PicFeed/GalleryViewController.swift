//
//  GalleryViewController.swift
//  PicFeed
//
//  Created by Luay Younus on 3/29/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit

protocol GalleryViewControllerDelegate : class { //class here is a type.. just a weird way delegates are defined
    func galleryController(didSelect Image: UIImage)
}

class GalleryViewController: UIViewController {
    
    weak var delegate : GalleryViewControllerDelegate?

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var allPosts = [Post](){
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.collectionViewLayout = GalleryCollectionViewLayout(columns: 2)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        update()
    }
    
    func update(){
        CloudKit.shared.getPost { (posts) in
            if let posts = posts {
                self.allPosts = posts
            }
        }
    }
    
    
    @IBAction func userPinched(_ sender: UIPinchGestureRecognizer) {
        
        guard let layout = collectionView.collectionViewLayout as? GalleryCollectionViewLayout else {return}
        
        switch sender.state {
        case .began:
            print("User Pinched!")
        case .changed:
            print("<-----User pinch changed!----->")
        case .ended:
            print("Pinch ended.")
            
            //the following is a ternary operator vs. nil coalesing, which is a different type that uses '??'
            let columns = sender.velocity > 0 ? layout.columns - 1 : layout.columns + 1
            
            if columns < 1 || columns > 10 {return}
            
            collectionView.setCollectionViewLayout(GalleryCollectionViewLayout(columns:columns), animated: true)
        default:
            print("Unknown sender state.")
        }
    }

}


//MARK: UICollectionViewdataSource Extension
extension GalleryViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.identifier, for: indexPath) as! GalleryCell
        
        cell.post = self.allPosts[indexPath.row]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = self.delegate else { return }
        
        let selectedPost = self.allPosts[indexPath.row]
        Filters.originalImage = selectedPost.image
        delegate.galleryController(didSelect: selectedPost.image)
    }
}
