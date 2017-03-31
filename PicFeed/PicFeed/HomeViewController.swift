//
//  HomeViewCellViewController.swift
//  PicFeed
//
//  Created by Luay Younus on 3/27/17.
//  Copyright © 2017 Luay Younus. All rights reserved.

import UIKit
import Social

class HomeViewController: UIViewController, UINavigationControllerDelegate {
    
    let filterNames = [FilterName.vintage, FilterName.blackAndWhite, FilterName.chrome, FilterName.colorSpace, FilterName.dark]
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var saveToCloudOption: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filtersOption: UIButton!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterShowWhenImagePicked: NSLayoutConstraint!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        setupGalleryDelegate()
        
        saveToCloudOption.isHidden = true
    }
    
//Changes the status bar text color to light (white)
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    func setupGalleryDelegate(){
        if let tabBarController = self.tabBarController {
            guard let viewControllers = tabBarController.viewControllers else { return }
            
            guard let galleryController = viewControllers[1] as? GalleryViewController else {return}
            
            galleryController.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.4){
            self.view.layoutIfNeeded()
        }
        mainLabel.layer.masksToBounds = true
        mainLabel.layer.cornerRadius = 8.0
        
        filtersOption.layer.masksToBounds = true
        filtersOption.layer.cornerRadius = 8.0
        
        saveToCloudOption.layer.masksToBounds = true
        saveToCloudOption.layer.cornerRadius = 8.0
    }
    
    func animateOriginalImage(imageView: UIImageView){
        UIView.transition(with: imageView, duration: 2, options: .curveEaseIn, animations: nil, completion: nil)
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType){
        
        self.imagePicker.delegate = self
        
        self.imagePicker.sourceType = sourceType
        
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
        @IBAction func imageTapped(_ sender: Any) {
            //save button color restoration and Touch event enabled again
            
            print("User Tapped Image!")
            self.presentActionSheet()
    }
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
        
        if let image = self.imageView.image {
            
            let newPost = Post(image: image, date: nil)
            CloudKit.shared.save(post: newPost, completion: { (success) in
                
                if success {
                    self.saveToCloudOption.backgroundColor = UIColor.lightGray
                    self.saveToCloudOption.isUserInteractionEnabled = false
                    print("Saved PostSuccessfully to CloudKit!")
                    
                } else {
                    print("Unsuccessful save to CloudKit")
                }
                
            })
        }
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        
        //show the Save Button
        saveToCloudOption.isHidden = false
        //show the filter Button
        filterShowWhenImagePicked.constant = -50

        
        guard let image = self.imageView.image else { return }
        
        switch self.collectionViewHeightConstraint.constant {
        case CGFloat(0):
            self.collectionViewHeightConstraint.constant = 150
        case CGFloat(150):
            self.collectionViewHeightConstraint.constant = 0
        default:
            return
        }
        
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
        
        self.imageView.image = image
    }
    
    
    @IBAction func userLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
            
            guard let composeController = SLComposeViewController(forServiceType: SLServiceTypeTwitter) else {return}
        
        composeController.add(self.imageView.image)
        
        self.present(composeController, animated: true, completion: nil)
        }
    }
    
    
    
    func presentActionSheet(){
        
        let actionSheetController = UIAlertController(title: "Source", message: "Please Select Source Type", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            
            self.presentImagePickerWith(sourceType: .camera)
            self.imagePicker.allowsEditing = true
        }
        
        let photoAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.presentImagePickerWith(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        actionSheetController.addAction(cameraAction)
        actionSheetController.addAction(photoAction)
        
        if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad {
            actionSheetController.addAction(cancelAction)
        }
        
        //PopOver for the iPad
        let popover = actionSheetController.popoverPresentationController
        popover?.sourceView = imageView
        popover?.sourceRect = imageView.bounds
        popover?.permittedArrowDirections = UIPopoverArrowDirection.any //the direction of popover
        
        //chain together those events with present
        self.present(actionSheetController, animated: true, completion: nil)
    }
}

//MARK: UIImagePickerController Delegate
extension HomeViewController : UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil) //HomeViewController tells the imagePicker to dismiss!
    }
    
    
    //We use info[ ] without quotations inside to make sure we didnt type in a wrong key
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //print("Info: \(info)")
        var image = UIImage()
        
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = originalImage
            Filters.originalImage = originalImage
            self.collectionView.reloadData()
        }
        
        //closing the filter cell
        self.collectionViewHeightConstraint.constant = 0
        
        //show the save Button
        saveToCloudOption.isHidden = false
        
        //save button color restoration and Touch event enabled again
        self.saveToCloudOption.backgroundColor = UIColor(rgb: 0x339966)
        self.saveToCloudOption.isUserInteractionEnabled = true

        
        //Showing the Filters Button when picking image from the photoLibrary
        filterShowWhenImagePicked.constant = 20
        
        //dismissing the picker after handing out the picked image to Filters
        self.dismiss(animated: true) {
            UIView.transition(with: self.imageView,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.imageView.image = image
            }, completion: nil)
        }
    }
}

//MARK: UICollectionView DataSouce
extension HomeViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.identifier, for: indexPath) as! FilterCell
        
        guard let originalImage = Filters.originalImage as UIImage? else { return filterCell }
        
        let targetSize = CGFloat(150)
        var resizeFactor : CGFloat
        if originalImage.size.height > originalImage.size.width {
            resizeFactor = targetSize / originalImage.size.width
        } else {
            resizeFactor = targetSize / originalImage.size.height
        }
        
        guard let resizedImage = originalImage.resize(size: CGSize(width: resizeFactor * originalImage.size.width , height: resizeFactor * originalImage.size.height)) else { return filterCell }
        
        let filterName = self.filterNames[indexPath.row]
        
        Filters.filter(name: filterName, image: resizedImage) { (filteredImage) in
            filterCell.imageView.image = filteredImage
            filterCell.filterName.text = Filters.sharedFilters.filterNamesArray[indexPath.row]
        }
        
        return filterCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterNames.count
    }
}

//Mark: UICollectionView Delegate
extension HomeViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFilterName = filterNames[indexPath.row]
        Filters.filter(name: selectedFilterName, image: Filters.originalImage!) { (filteredImage) in
            self.imageView.image = filteredImage
        }
    }
}


//MARK: GalleryViewController Delegate
extension HomeViewController : GalleryViewControllerDelegate{
    
    func galleryController(didSelect image: UIImage){
        
        //closing the filter cell
        self.collectionViewHeightConstraint.constant = 0
        
        //show save
        saveToCloudOption.isHidden = false
        
        //show filter
        filterShowWhenImagePicked.constant = 20
        
        //save button color restoration and Touch event enabled again
        self.saveToCloudOption.backgroundColor = UIColor(rgb: 0x339966)
        self.saveToCloudOption.isUserInteractionEnabled = true

        self.imageView.image = image
        self.tabBarController?.selectedIndex = 0
        
    }
}

//MARK: HEX Color extension
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
