//
//  DetailView.swift
//  Handshake
//
//  Created by Michael Borgmann on 06/08/15.
//  Copyright (c) 2015 Michael Borgmann. All rights reserved.
//

import UIKit

class DetailView: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var notesField: UITextField!

    var item: Item?
    var email: String?
    var dismissBlock: (() -> ())?

    
    init() {
        super.init(nibName: "DetailView", bundle: nil)
        self.navigationItem.title = "Details"
        
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel:")
        navigationItem.leftBarButtonItem = cancelItem
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        priceField.delegate = self
        amountField.delegate = self
        notesField.delegate = self
        
        print ("Email: \(email)")


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        nameField.text = item?.name
        priceField.text = "\(item!.price)"
        amountField.text = "\(item!.amount)"
        notesField.text = item?.notes
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        view.endEditing(true)
        
        item!.name = nameField.text
        item!.amount = amountField.text.toInt()!
        item!.notes = notesField.text
        item!.price = (priceField.text as NSString).floatValue
        item!.email = email!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        priceField.resignFirstResponder()
        amountField.resignFirstResponder()
        notesField.resignFirstResponder()
        return true
    }

    
    @IBAction func saveItem(sender: AnyObject) {
        //presentingViewController!.dismissViewControllerAnimated(true, completion: dismissBlock)
        navigationController?.popViewControllerAnimated(true)
    }
    
    func cancel(sender: AnyObject) {
        //@IBAction func cancelButtonPressed(sender: AnyObject) {
        //ItemStore.sharedStore.removeItem(item!)
        navigationController?.popViewControllerAnimated(true)
        //presentingViewController!.dismissViewControllerAnimated(true) {
        //println("Cancelling new item creation and asking to dismiss NameViewController.")
    }
}
