//
//  TabNameStore.swift
//  Handshake
//
//  Created by Michael Borgmann on 16/08/15.
//  Copyright (c) 2015 Michael Borgmann. All rights reserved.
//

import Foundation

class TabNameStore: NSObject {

    private(set) var allTabNames = [TabName]()
    
    private override init() {
        super.init()
        if let loaded = NSKeyedUnarchiver.unarchiveObjectWithFile(itemArchivePath) as? [(TabName)] {
            allTabNames = loaded
        }
    }
    
    class var sharedStore: TabNameStore {
        struct Singleton {
            static let sharedStore: TabNameStore = TabNameStore()
        }
        return Singleton.sharedStore
    }
    
    func createTabName() -> TabName {
        let tabName = TabName.randomTab()
        allTabNames += [tabName]
        return tabName
    }
    
    func removeTabName(tabName: TabName) {
        allTabNames = allTabNames.filter({$0 !== tabName})
    }
    
    func moveTabNameAtIndex(fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        var tabName = allTabNames[fromIndex]
        allTabNames.removeAtIndex(fromIndex)
        allTabNames.insert(tabName, atIndex: toIndex)
    }
        
    var itemArchivePath: String {
        //let documentDirectories = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentationDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        //let documentDirectory = documentDirectories[0] as! String
        //return documentDirectory.stringByAppendingPathComponent("tabName.archive")
        return NSTemporaryDirectory() + "tabName.archive"
    }
    
    func saveChanges() -> Bool {
        //print("\(allTabNames)")
        return NSKeyedArchiver.archiveRootObject(allTabNames, toFile: itemArchivePath)
    }
    
}
