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
    var numVertices: Int!
    
    var defaultVerticeIndex = [Int]()
    var vertices = [CGPoint]()
    //var coordinateLookupTable = [CGPoint]() //where all time slots should be
    
    var anchorView: UIView! //to allow all vertices to be move-able
    
    var anchorViewArray = [UIView]() //to allow all vertices to be move-able
    
//    override init(frame: CGRect) {
    init(frame: CGRect , numVertices : Int) {
        super.init(frame: frame)
        self.numVertices = numVertices
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
       // print("index \(index) .x \(x) .y \(y)")
    
        return CGPoint(x: x, y: y)
        
    }
    
    func calCoordinateFromIndex( o: CGPoint, r: CGFloat, i: Int) -> CGPoint{
        let x = calCoordinateFromIndex(i).x * r + o.x
        let y = calCoordinateFromIndex(i).y * r + o.y
        return CGPoint(x: x, y: y)
        
    }
    func setup() {
        soundFile = "just blaze bksnare2"
//        print(numVertices)
        switch (numVertices){
        case 3:
            defaultVerticeIndex = [0, 5, 11]
            break;
        case 4:
            defaultVerticeIndex = [0,4,8,12]
            break;
        case 5:
            defaultVerticeIndex = [0,3,6,10,13]
            break;
        case 6:
            defaultVerticeIndex = [1,4,7,9,12,15]
            break;
        case 8:
            defaultVerticeIndex = [1,3,5,7,9,11,13,15]
            break;
        default:
            print("error")
            defaultVerticeIndex = [0]
            break;
            
            
        }

        
        //calculate each vertex and add to array
        let origin = CGPoint(x: 33, y: 33)
        for var i = 0; i < defaultVerticeIndex.count ; ++i {
            vertices.append (calCoordinateFromIndex(origin, r: 30, i: defaultVerticeIndex[i]))
        }

        //NOTE THAT THE VERTICE IS NOT SCALING IWHT THE IAMGES!!!
        for var i = 0; i < defaultVerticeIndex.count ; ++i {
            var anchorView: UIView!
            anchorView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            anchorView.userInteractionEnabled = true
//            anchorView.backgroundColor = UIColor.purpleColor()
            anchorView.backgroundColor = UIColor.clearColor()
            anchorView.center = calCoordinateFromIndex(origin, r: 30, i: defaultVerticeIndex[i])
            addSubview(anchorView)
            
            let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "onLongPressAnchor:")
            gestureRecognizer.minimumPressDuration = 0
            anchorView.addGestureRecognizer(gestureRecognizer)
            anchorViewArray.append(anchorView)
        }

        backgroundColor = UIColor.clearColor()
//          backgroundColor = UIColor.orangeColor()
    }


    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Draw this shape
        if (anchorViewArray.count > 1 ){
            let path = UIBezierPath()
            path.moveToPoint(anchorViewArray[0].center)
            for var i = 1 ; i < vertices.count ; ++i {
                path.addLineToPoint(anchorViewArray[i].center)
                //                print("index \(i) .x \(vertices[i].x) .y \(vertices[i].y)")
            }
            path.closePath()
            UIColor.blueColor().setFill()
            path.fill()
            path.lineWidth = 2.0
            UIColor.grayColor().setStroke()
            path.stroke()
        }

        //// if we just need static image, use this !
        
//        if (vertices.count > 1 ){
//            let path = UIBezierPath()
//            path.moveToPoint(vertices[0])
//            for var i = 1 ; i < vertices.count ; ++i {
//                path.addLineToPoint(vertices[i])
////                print("index \(i) .x \(vertices[i].x) .y \(vertices[i].y)")
//            }
//            path.closePath()
//            UIColor.blueColor().setFill()
//            path.fill()
//            path.lineWidth = 2.0
//            UIColor.grayColor().setStroke()
//            path.stroke()
//        }
    }
    
    func onLongPressAnchor(sender: UILongPressGestureRecognizer) {
        let v = sender.view!
        let location = sender.locationInView(self)
        
        v.center = location
        
        // Triggers drawRect
        setNeedsDisplay()
    }

}
