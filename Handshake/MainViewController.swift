//
//  LoginViewController.swift
//  Handshake
//
//  Created by Michael Borgmann on 27/06/15.
//  Copyright (c) 2015 Michael Borgmann. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let mainView = MainView()
        self.view = mainView
    }
    
    override func viewDidAppear(animated: Bool) {
        let isLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isLoggedIn")
        
        if (!isLoggedIn) {
            showLoginView()
        } else {
            showAppView()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showLoginView() {
        let userAccountViewController = UserAccountViewController()
        let navigationController = UINavigationController(rootViewController: userAccountViewController)
        navigationController.modalTransitionStyle = .FlipHorizontal
        navigationController.modalPresentationStyle = .FormSheet
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func showAppView() {
        let handshakeViewController = HandshakeViewController(style: UITableViewStyle.Plain)
        let navigationController = UINavigationController(rootViewController: handshakeViewController)
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func logoutButton() {
        let button = UIButton();
        button.setTitle("Logout", forState: .Normal)
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.frame = CGRectMake(15, 50, 200, 100)
        button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
    }
    
    func buttonPressed(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        showLoginView()
    }
}
