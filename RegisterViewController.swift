//
//  RegisterViewController.swift
//  Handshake
//
//  Created by Michael Borgmann on 28/06/15.
//  Copyright (c) 2015 Michael Borgmann. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var pictureButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "RegisterViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if nameField.isFirstResponder() {
            emailField.becomeFirstResponder()
        } else if emailField.isFirstResponder() {
            passwordField.becomeFirstResponder()
        } else if passwordField.isFirstResponder() {
            passwordField.resignFirstResponder()
        }
        
        return true
    }
    
    
    @IBAction func backgroundTapped(sender: AnyObject) {
        self.view.endEditing(true)
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
    
    @IBAction func register(sender: AnyObject) {
        let name = nameField.text
        let email = emailField.text
        let password = passwordField.text
        
        // check for empty fields
        if name.isEmpty {
            alertMessage(message: "Please enter your full name.")
            return
        } else if email.isEmpty {
            alertMessage(message: "Please enter a valid email address.")
            return
        } else if password.isEmpty {
            alertMessage(message: "A password must have at least 8 characters, have at least 2 of lower case, upper case, numbers, or other characters, and not contain the beginning part of your email address.")
            return
        }
        
        // Send user data to server side
        let url = NSURL(string: "http://webapi.michaelborgmann.com/handshake/includes/register.php")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let postString = "name=\(name)&email=\(email)&password=\(password)"
        //let postString = "name=Mitch&email=mitch@mail.com&password=123456"
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        // HTTP POST Request
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as? NSDictionary
            
            if let parseJSON = json {
                var resultValue = parseJSON["status"] as? String
                println("result: \(resultValue)")
            
                var isUserRegistered:Bool = false;
                if resultValue == "Success" {
                    isUserRegistered = true;
                }
                
                var messageToDisplay: String = parseJSON["message"] as! String!
                if !isUserRegistered {
                    messageToDisplay = parseJSON["message"] as! String
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    // Display alert message with confirmation
                    var alert = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let okayAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        action in self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    
                    alert.addAction(okayAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        }
        
        task.resume()

    }
    
    func alertMessage(title: String? = nil, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okayAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(okayAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}