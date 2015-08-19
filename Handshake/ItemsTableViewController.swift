//
//  ItemsTableViewController.swift
//  Handshake
//
//  Created by Michael Borgmann on 16/08/15.
//  Copyright (c) 2015 Michael Borgmann. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController, UITableViewDelegate {
    
    var email: String?
    
    override init(style: UITableViewStyle) {
        super.init(style: UITableViewStyle.Plain)
        self.navigationItem.title = "Items"
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "add:")
        navigationItem.rightBarButtonItem = addItem
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ItemCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "ItemCell")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemStore.sharedStore.allItems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        let item = ItemStore.sharedStore.allItems[indexPath.row]
        //cell.textLabel?.text = tabName.description
        
        if email != item.email {
            cell.hidden = true
        }
            
        cell.amountLabel.text = "\(item.amount)"
        cell.nameLabel.text = item.name
        cell.priceLabel.text = "\(item.price)"

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight: CGFloat = 44
        
        let item = ItemStore.sharedStore.allItems[indexPath.row]
        if email != item.email {
            rowHeight = 0.0
        }
        
        return rowHeight
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            var item = ItemStore.sharedStore.allItems[indexPath.row]
            ItemStore.sharedStore.removeItem(item)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        ItemStore.sharedStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = ItemStore.sharedStore.allItems[indexPath.row]

        let detailView = DetailView()
        detailView.item = item
        detailView.email = email
        
        self.navigationController?.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    @IBAction func logout(sender: UIButton) {
        print("button pressed")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func add(sender: AnyObject) {
        //@IBAction func doneButtonPressed(sender: AnyObject) {
        let item = ItemStore.sharedStore.createItem()

        let detailView = DetailView()
        detailView.item = item
        detailView.email = email
        
        self.navigationController?.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        self.navigationController?.pushViewController(detailView, animated: true)
    }

}
