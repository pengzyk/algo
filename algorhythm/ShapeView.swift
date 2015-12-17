//
//  ShapeView.swift
//  algorhythm
//
//  Created by Timothy Lee on 12/16/15.
//  Copyright © 2015 sansserif. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation



class ShapeView: UIView {
    
    
    var soundFile: String!
    var numPoints: Int!
    
    var defaultVerticeIndex = [Int]()
    var vertices = [CGPoint]()
    //var coordinateLookupTable = [CGPoint]() //where all time slots should be
    
    var anchorView: UIView! //to allow all vertices to be move-able
    
    var anchorViewArray = [UIView]() //to allow all vertices to be move-able
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func calCoordinateFromIndex( index: Int) -> CGPoint {
        //index is offset by a quarter
        //hence the treatment
        let newIndex =  index - TOTAL_TIME_SLOTS/4
        let rad = Double(newIndex) * M_PI * 2.0 / Double(TOTAL_TIME_SLOTS)
        let x = cos(rad)
        let y = sin(rad)
        print("index \(index) .x \(x) .y \(y)")
    
        return CGPoint(x: x, y: y)
        
    }
    
    func calCoordinateFromIndex( o: CGPoint, r: CGFloat, i: Int) -> CGPoint{
        let x = calCoordinateFromIndex(i).x * r + o.x
        let y = calCoordinateFromIndex(i).y * r + o.y
        return CGPoint(x: x, y: y)
        
    }
    func setup() {
        soundFile = "just blaze bksnare2"
        numPoints = 3
        
        defaultVerticeIndex = [1, 8, 12]
        //calculate each vertex and add to array
        let origin = CGPoint(x: 32, y: 32)
        for var i = 0; i < defaultVerticeIndex.count ; ++i {
            vertices.append (calCoordinateFromIndex(origin, r: 30, i: defaultVerticeIndex[i]))
        }
        
        
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


    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Draw this shape
        if (vertices.count > 1 ){
            let path = UIBezierPath()
            path.moveToPoint(vertices[0])
            for var i = 1 ; i < vertices.count ; ++i {
                path.addLineToPoint(vertices[i])
//                print("index \(i) .x \(vertices[i].x) .y \(vertices[i].y)")
            }
            path.closePath()
            UIColor.blueColor().setFill()
            path.fill()
            path.lineWidth = 2.0
            UIColor.grayColor().setStroke()
            path.stroke()
        }
    }
    
    func onLongPress(sender: UILongPressGestureRecognizer) {
        let v = sender.view!
        let location = sender.locationInView(self)
        
        v.center = location
        
        // Triggers drawRect
        setNeedsDisplay()
    }

}
