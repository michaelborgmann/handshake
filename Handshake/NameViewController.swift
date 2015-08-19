//
//  NameViewController.swift
//  Handshake
//
//  Created by Michael Borgmann on 16/08/15.
//  Copyright (c) 2015 Michael Borgmann. All rights reserved.
//

import UIKit

class NameViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var infoField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var limitField: UITextField!
    
    var tabName: TabName?
    var dismissBlock: (() -> ())?
    /*
    init(item: Item) {
        NSException(name: "Wrong initializer", reason: "Use init(isNew:)", userInfo: nil).raise()
        super.init(nibName: nil, bundle: nil)
    }
    */
    init(isNew: Bool) {
    //override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "NameViewController", bundle: nil)

        let addContact = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "save:")
        navigationItem.rightBarButtonItem = addContact
        
        let cancelContact = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel:")
        navigationItem.leftBarButtonItem = cancelContact
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        infoField?.text = tabName?.info
        emailField.text = tabName?.email
        limitField?.text = "\(tabName!.limit)"
        
        //self.shareButton.state(UIControlState.Disabled)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        view.endEditing(true)
        
        tabName!.info = infoField.text
        tabName!.email = emailField.text
        tabName!.limit = (limitField.text as NSString).floatValue
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoField.delegate = self
        emailField.delegate = self
        limitField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        infoField.resignFirstResponder()
        emailField.resignFirstResponder()
        limitField.resignFirstResponder()
        return true
    }

    func cancel(sender: AnyObject) {
    //@IBAction func cancelButtonPressed(sender: AnyObject) {
        TabNameStore.sharedStore.removeTabName(tabName!)
        presentingViewController!.dismissViewControllerAnimated(true) {
            println("Cancelling new item creation and asking to dismiss NameViewController.")
        }
    }
    
    func save(sender: AnyObject) {
    //@IBAction func doneButtonPressed(sender: AnyObject) {
        presentingViewController!.dismissViewControllerAnimated(true, completion: dismissBlock)
    }
    
}
