//
//  TabName.swift
//  Handshake
//
//  Created by Michael Borgmann on 16/08/15.
//  Copyright (c) 2015 Michael Borgmann. All rights reserved.
//

import Foundation

class TabName: NSObject, NSCoding {
    var info: String
    var owner: String
    var iou: String
    var limit: Float
    var email: String
    
    override var description: String {
        return ("Info: \(self.info)\nOwner: \(self.owner)\nIOU: \(self.iou)\nEmail: \(self.email)\nLimit: \(self.limit)\n")
    }
    
    @objc required convenience init(coder aDecoder: NSCoder) {
        self.init(info: "", owner: "", iou: "", email: "", limit: 0.0)
        info = aDecoder.decodeObjectForKey("tabName.info") as! String
        owner = aDecoder.decodeObjectForKey("tabName.owner") as! String
        iou = aDecoder.decodeObjectForKey("tabName.iou") as! String
        limit = aDecoder.decodeObjectForKey("tabName.limit") as! Float
        email = aDecoder.decodeObjectForKey("tabName.email") as! String
    }
    
    @objc init(info: String, owner: String, iou: String, email: String, limit: Float) {
        self.info = info
        self.owner = owner
        self.iou = iou
        self.limit = limit
        self.email = email
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(info, forKey: "tabName.info")
        aCoder.encodeObject(owner, forKey: "tabName.owner")
        aCoder.encodeObject(iou, forKey: "tabName.iou")
        aCoder.encodeObject(limit, forKey: "tabName.limit")
        aCoder.encodeObject(email, forKey: "tabName.email")
    }
    
    class func randomTab() -> TabName {
        
        let randomInfoList = ["some info", "more info"]
        let randomIOUList = ["Alice", "Bob", "Eve"]
        
        let infoIndex = Int(arc4random()) % randomInfoList.count
        let iouIndex = Int(arc4random()) % randomIOUList.count
        
        let randomInfo = randomInfoList[infoIndex]
        let randomIOU = randomIOUList[iouIndex]
        let randomLimit = Float(arc4random()) % 100
        
        let newTabName = TabName(info: randomInfo, owner: "michaelborgmann@mailbox.org", iou: randomIOU, email: "\(randomIOU)@mail.com", limit: randomLimit)
        return newTabName
    }
}
    