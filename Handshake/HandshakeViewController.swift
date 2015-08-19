//
//  HandshakeViewController.swift
//  Handshake
//
//  Created by Michael Borgmann on 28/07/15.
//  Copyright (c) 2015 Michael Borgmann. All rights reserved.
//

import UIKit

class HandshakeViewController: UITableViewController, UITableViewDelegate {
    
    var _indexPath: NSIndexPath?
    var _headerView: UIView?
    @IBOutlet var headerView: UIView! {
        get {
            if _headerView == nil {
                NSBundle.mainBundle().loadNibNamed("HeaderView", owner: self, options: nil)
            }
            return _headerView
        }
        set {
            _headerView = newValue
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override init(style: UITableViewStyle) {
        super.init(style: UITableViewStyle.Plain)
        self.navigationItem.title = "Handshake - IOU"
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: nil)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TabNameCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "TabNameCell")
        
        let header: UIView = self.headerView
        tableView.tableHeaderView = header
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TabNameStore.sharedStore.allTabNames.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("TabNameCell", forIndexPath: indexPath) as! TabNameCell
        
        let tabName = TabNameStore.sharedStore.allTabNames[indexPath.row]
        //cell.textLabel?.text = tabName.description
        
        cell.nameLabel.text = tabName.iou
        cell.emailLabel.text = tabName.email
        cell.priceLabel.text = "0"
        cell.thumbnailView = nil
        
        let count = ItemStore.sharedStore.allItems.count
        for var i = 0; i < count; ++i {
            var item = ItemStore.sharedStore.allItems[i]
            if cell.emailLabel.text == item.email {
                var cellPrice: NSString = cell.priceLabel.text!
                var cellFloat = cellPrice.floatValue
                cellFloat += item.price
                cell.priceLabel.text = "\(cellFloat)"
            }
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            var tabName = TabNameStore.sharedStore.allTabNames[indexPath.row]
            TabNameStore.sharedStore.removeTabName(tabName)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        TabNameStore.sharedStore.moveTabNameAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tabName = TabNameStore.sharedStore.allTabNames[indexPath.row]
        
        let itemsView = ItemsTableViewController(style: .Plain)
        itemsView.email = tabName.email
        
        self.navigationController?.pushViewController(itemsView, animated: true)
    }
    
    @IBAction func logout(sender: UIButton) {
        print("button pressed")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addTabName(sender: AnyObject) {

        let newTabName = TabNameStore.sharedStore.createTabName()
        
        let nameView = NameViewController(isNew: true)
        nameView.tabName = newTabName
        
        nameView.dismissBlock = {
            self.tableView.reloadData()
            println("Saving Item and asking to dismiss DetailViewController")
        }
        
        self.navigationController?.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        //self.presentViewController(nameView, animated: true, completion: nil)
        self.navigationController?.pushViewController(nameView, animated: true)
    }

}
