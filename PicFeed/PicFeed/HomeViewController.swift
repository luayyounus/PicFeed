//
//  HomeViewCellViewController.swift
//  PicFeed
//
//  Created by Luay Younus on 3/27/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController() //initializing it in memory
    
    
    @IBOutlet weak var imageView: UIImageView!


    override func viewDidLoad() { //its over-riding methods from the super class(parent class)
        super.viewDidLoad()
        print("HEllooooo")

        // Do any additional setup after loading the view.
    }

    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType){
        
        self.imagePicker.delegate = self //assigning the delegate of the imagePicker to this HomeViewController
        
        self.imagePicker.sourceType = sourceType //
        
        
        
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
        print("Info: \(info)")
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
    
        //dismissing the picker on line 45
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func imageTapped(_ sender: Any) {
        print("User Tapped Image!")
        
        self.presentActionSheet()
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
        actionSheetController.addAction(cancelAction)
        
        //chain together those events with present
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
}
