//
//  UserAccountViewController.swift
//  Handshake
//
//  Created by Michael Borgmann on 27/06/15.
//  Copyright (c) 2015 Michael Borgmann. All rights reserved.
//

import UIKit

class UserAccountViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "UserAccountViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(sender: AnyObject) {
        let registerView = RegisterViewController()
        self.navigationController?.pushViewController(registerView, animated: true)
    }
    
    @IBAction func login(sender: AnyObject) {
        let loginView = LoginViewController()
        self.navigationController?.pushViewController(loginView, animated: true)
    }
    
}
