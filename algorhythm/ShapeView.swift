//
//  ShapeView.swift
//  algorhythm
//
//  Created by Timothy Lee on 12/16/15.
//  Copyright © 2015 sansserif. All rights reserved.
//

import UIKit

class ShapeView: UIView {
    
    var soundFile: String!
    var numPoints: Int!
    
    var anchorView: UIView!
    
    func setup() {
        soundFile = "just blaze bksnare2"
        numPoints = 3
        
        anchorView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        anchorView.userInteractionEnabled = true
        anchorView.backgroundColor = UIColor.purpleColor()
        anchorView.center = CGPoint(x: 0, y: 0)
        addSubview(anchorView)
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "onLongPress:")
        gestureRecognizer.minimumPressDuration = 0
        anchorView.addGestureRecognizer(gestureRecognizer)
        
        backgroundColor = UIColor.orangeColor()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let path = UIBezierPath()
        path.moveToPoint(anchorView.center)
        path.addLineToPoint(CGPoint(x: 50, y: 50))
        path.addLineToPoint(CGPoint(x: 0, y: 50))
        
        UIColor.blueColor().setFill()
        
        path.closePath()
        path.fill()
    }
    
    func onLongPress(sender: UILongPressGestureRecognizer) {
        let v = sender.view!
        let location = sender.locationInView(self)
        
        v.center = location
        
        // Triggers drawRect
        setNeedsDisplay()
    }

}
