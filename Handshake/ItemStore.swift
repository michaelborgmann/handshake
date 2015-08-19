//
//  ItemStore.swift
//  Handshake
//
//  Created by Michael Borgmann on 06/08/15.
//  Copyright (c) 2015 Michael Borgmann. All rights reserved.
//

import UIKit

class ItemStore: NSObject {
    
    private(set) var allItems = [Item]()
    
    private override init() {
        super.init()
        if let loaded = NSKeyedUnarchiver.unarchiveObjectWithFile(itemArchivePath) as? [(Item)] {
            allItems = loaded
        }
    }
    
    class var sharedStore: ItemStore {
        struct Singleton {
            static let sharedStore: ItemStore = ItemStore()
        }
        return Singleton.sharedStore
    }
    
    func createItem() -> Item {
        let item = Item.randomItem()
        allItems += [item]
        return item
    }

    func removeItem(item: Item) {
        allItems = allItems.filter({$0 !== item})
    }

    func moveItemAtIndex(fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return;
        }
        
        var item = allItems[fromIndex]
        allItems.removeAtIndex(fromIndex)
        allItems.insert(item, atIndex: toIndex)
    }
    
    var itemArchivePath: String {
        return NSTemporaryDirectory() + "item.archive"
    }
    
    func saveChanges() -> Bool {
        print("\(allItems)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchivePath)
    }
}
