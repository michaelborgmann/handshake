//
//  LoginView.swift
//  Handshake
//
//  Created by Michael Borgmann on 25/06/15.
//  Copyright (c) 2015 Michael Borgmann. All rights reserved.
//

import UIKit

class MainView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
        
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }
        
    override func drawRect(rect: CGRect) {
            
        let bounds = self.bounds
        let image = UIImage(named: "marinha.jpeg")
        
        let percent = (bounds.size.width / bounds.size.height) * 100
        let width = 3000 * (bounds.size.width / bounds.size.height)
        
        let cutout = CGRectMake(image!.size.width / 2 - width/2, 0, width, image!.size.height)
        let reference = CGImageCreateWithImageInRect(image!.CGImage, cutout)
        let frame = UIImage(CGImage: reference)
        
        frame!.drawInRect(CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        
    }
    
}