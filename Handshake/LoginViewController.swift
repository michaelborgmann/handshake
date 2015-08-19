//
//  LoginViewController.swift
//  Handshake
//
//  Created by Michael Borgmann on 29/06/15.
//  Copyright (c) 2015 Michael Borgmann. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "LoginViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if emailField.isFirstResponder() {
            passwordField.becomeFirstResponder()
        } else if passwordField.isFirstResponder() {
            passwordField.resignFirstResponder()
        }
        
        return true
    }
    
    @IBAction func login(sender: AnyObject) {
        
        let email = emailField.text
        let password = passwordField.text
        
        if email.isEmpty || password.isEmpty {
            alertMessage(title: "Handshake", message: "The email or password you entered was incorrect. Please try again.")
            return
        }
        
        // FIXME: for offline debuggin and development only
        let offline = true
        if offline {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLoggedIn")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
        
            // Send user data to server side
            let url = NSURL(string: "http://webapi.domain.com/includes/login.php")
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
        
            let postString = "email=\(email)&password=\(password)"
        
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
            
                if error != nil {
                    println("error=\(error)")
                    return
                }
            
                println("response = \(response)")
            
                let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("responseString = \(responseString)")
            
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as? NSDictionary
            
                if let parseJSON = json {
                    var resultValue = parseJSON["status"] as? String
                    println("result: \(resultValue)")
            
                    if (resultValue == "Success") {
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isLoggedIn")
                        NSUserDefaults.standardUserDefaults().synchronize();
                    
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }
            task.resume()
        }
    }
        
    func alertMessage(title: String? = nil, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okayAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(okayAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
