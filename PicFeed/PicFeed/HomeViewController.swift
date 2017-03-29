//
//  HomeViewCellViewController.swift
//  PicFeed
//
//  Created by Luay Younus on 3/27/17.
//  Copyright © 2017 Luay Younus. All rights reserved.


import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController() //initializing it in memory
    
    
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var filterButtonTopConstraint: NSLayoutConstraint!
    

    override func viewDidLoad() { //its over-riding methods from the super class(parent class)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        filterButtonTopConstraint.constant = -70
        UIView.animate(withDuration: 0.4){
            self.view.layoutIfNeeded()
        }
    }
    
    func animateOriginalImage(imageView: UIImageView){
        UIView.transition(with: imageView, duration: 2, options: .curveEaseIn, animations: nil, completion: nil)
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType){
        
        self.imagePicker.delegate = self //assigning the delegate of the imagePicker to this HomeViewController
        
        self.imagePicker.sourceType = sourceType
        
        
        
        //self.imagePicker is what we will present
        self.present(self.imagePicker, animated: true, completion: nil)
        
    }
    
    //if the user is presented with the image and clicked cancel, it will get back to the home view controller
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil) //HomeViewController tells the imagePicker to dismiss! GET OUT OF MY LIFE!
    }
    
    // didFinishPickingMediaWithInfo coming from the ImgaeDelegate protocol
    //info[ ] without quotations inside to make sure we didnt type in a wrong key
    //printing info in the console to show image type, location, size, orientation, scale and a lot others ......
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //print("Info: \(info)")
        var image = UIImage()
        
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = originalImage
            Filters.originalImage = originalImage
        }
        
        //dismissing the picker on line 45
        self.dismiss(animated: true) {
            // After dismissing picker controller, do the transition
            UIView.transition(with: self.imageView,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.imageView.image = image
            }, completion: nil)
        }
    }

    @IBAction func imageTapped(_ sender: Any) {
        print("User Tapped Image!")
        
        self.presentActionSheet()
    }
    
    @IBAction func postButtonPressed(_ sender: Any) {
        
        if let image = self.imageView.image {
            
            let newPost = Post(image: image)
            CloudKit.shared.save(post: newPost, completion: { (success) in
                
                if success {
                    print("Saved PostSuccessfully to CloudKit!")
                    
                } else {
                    print("Unsuccessful save to CloudKit")
                }
                
            })
        }
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        
        guard let image = self.imageView.image else { return } // if there's no image available, leave safely
        
        let alertController = UIAlertController(title: "Filter", message: "Please select a filter", preferredStyle: .alert)
        
        let blackAndWhiteAction = UIAlertAction(title: "Black & White", style: .default){ (action) in
            Filters.filter(name: .blackAndWhite, image: image, completion: {(filteredImage) in
                self.imageView.image = filteredImage
            })
            
        }
        
        let vintageAction = UIAlertAction(title: "Vintage", style: .default) { (action) in
            Filters.filter(name: .vintage, image: image, completion: { (filteredImage) in
                self.imageView.image = filteredImage
            })
        }
        
//        chrome = "CIPhotoEffectChrome"
//        colorSpace = "CIColorCubeWithColorSpace"
//        darkAndSexy = "CIColorPolynomial"
        
        let chrome = UIAlertAction(title: "Chrome", style: .default) { (action) in
            Filters.filter(name: .chrome, image: image, completion: { (filteredImage) in
                self.imageView.image = filteredImage
            })
        }
        
        let colorSpace = UIAlertAction(title: "Color Space", style: .default) { (action) in
            Filters.filter(name: .colorSpace, image: image, completion: { (filteredImage) in
                self.imageView.image = filteredImage
            })
        }
        
        let darkAndSexy = UIAlertAction(title: "Dark & Sexy", style: .default) { (action) in
            Filters.filter(name: .darkAndSexy, image: image, completion: { (filteredImage) in
                self.imageView.image = filteredImage
            })
            
        }
        
        
        let resetAction = UIAlertAction(title: "Reset Image", style: .destructive) {(action) in
            self.imageView.image = Filters.originalImage
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:nil)
        
        alertController.addAction(blackAndWhiteAction)
        alertController.addAction(vintageAction)
        alertController.addAction(chrome)
        alertController.addAction(colorSpace)
        alertController.addAction(darkAndSexy)
        alertController.addAction(resetAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    
    func presentActionSheet(){
        
        
        //initializer the UIAlertController (it takes in Strings)
        let actionSheetController = UIAlertController(title: "Source", message: "Please Select Source Type", preferredStyle: .actionSheet)
        //preferredStyle is an Enum here because its a choice
        
        
        
        //select the source type of camera
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in //(action) defining the action for UIAlertAction
            
            self.presentImagePickerWith(sourceType: .camera)
            self.imagePicker.allowsEditing = true
            
        }
        
        let photoAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.presentImagePickerWith(sourceType: .photoLibrary)
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)

        
        //add those actions to controller with sheets
        actionSheetController.addAction(cameraAction)
        actionSheetController.addAction(photoAction)
        
        if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad {
            actionSheetController.addAction(cancelAction)
        }

        
        //for the ipad
        let popover = actionSheetController.popoverPresentationController
        popover?.sourceView = imageView
        popover?.sourceRect = imageView.bounds
        popover?.permittedArrowDirections = UIPopoverArrowDirection.any //the direction of popover
        
        //chain together those events with present
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
}
