//
//  CreateAccountViewController.swift
//  Handshake
//
//  Created by Michael Borgmann on 28/06/15.
//  Copyright (c) 2015 Michael Borgmann. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var pictureButton: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "CreateAccountViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePicture(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alert = UIAlertController(title: "Take Picture",
                                    message: "Personalize your Handshake account by uploading your photo",
                             preferredStyle: .Alert)
        let chooseFromGallery = UIAlertAction(title: "Choose from Gallery", style: UIAlertActionStyle.Default) {
            (UIAlertAction) in
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        let takePhoto = UIAlertAction(title: "Take a Photo", style: UIAlertActionStyle.Default) {
            (UIAlertAction) in
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        alert.addAction(chooseFromGallery)
        alert.addAction(takePhoto)
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.pictureView.image = picture
        }
        self.dismissViewControllerAnimated(true, completion: nil)

    }
}