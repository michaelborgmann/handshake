//
//  Item.swift
//  Handshake
//
//  Created by Michael Borgmann on 06/08/15.
//  Copyright (c) 2015 Michael Borgmann. All rights reserved.
//

import Foundation

class Item: NSObject, NSCoding {
   
    var name: String
    var price: Float
    var amount: Int
    var notes: String
    var email: String?
    
    override var description: String {
        return ("Name: \(name)\nPrice: \(price)\nAmount: \(amount)\nNotes: \(notes)\n")
    }

    @objc init(name: String, price: Float, amount: Int, notes: String) {
        self.name = name
        self.price = price
        self.amount = amount
        self.notes = notes

    }
    
    @objc required convenience init(coder aDecoder: NSCoder) {
        self.init(name: "", price: 0, amount: 0, notes: "")
        print("init items")
        name = aDecoder.decodeObjectForKey("item.name") as! String
        price = aDecoder.decodeObjectForKey("item.price") as! Float
        amount = aDecoder.decodeObjectForKey("item.amount") as! Int
        notes = aDecoder.decodeObjectForKey("item.notes") as! String
        email = aDecoder.decodeObjectForKey("item.email") as? String
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "item.name")
        aCoder.encodeObject(price, forKey: "item.price")
        aCoder.encodeObject(amount, forKey: "item.amount")
        aCoder.encodeObject(notes, forKey: "item.notes")
        aCoder.encodeObject(email, forKey: "item.email")
    }
    
    class func randomItem() -> Item {
        let randomNameList = ["iPhone", "iPad", "Macbook", "iMac", "iPod"]
        let randomNotesList = ["", "All right", "Beleza", "Mmmmmmh"]
        
        let nameIndex = Int(arc4random()) % randomNameList.count
        let notesIndex = Int(arc4random()) % randomNotesList.count
    
        let randomName = randomNameList[nameIndex]
        let randomNote = randomNotesList[notesIndex]
        let randomPrice = (Float(arc4random()) % 100) + 1
        let randomAmount = (Int(arc4random()) % 5) + 1
            
        let newItem = Item(name: randomName, price: randomPrice, amount: randomAmount, notes: randomNote)
        return newItem
    }
    
}
