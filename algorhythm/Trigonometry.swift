//
//  Trigonometry.swift
//  algorhythm
//
//  Created by Xu, Cheng on 12/21/15.
//  Copyright © 2015 sansserif. All rights reserved.
//

import Foundation
import UIKit

class Common {
    
    
    static func calCoordinateFromIndex( index: Int) -> CGPoint {
        //index is offset by a quarter
        //hence the treatment
        let newIndex =  index - TOTAL_TIME_SLOTS/4
        let rad = Double(newIndex) * M_PI * 2.0 / Double(TOTAL_TIME_SLOTS)
        let x = cos(rad)
        let y = sin(rad)
        // print("index \(index) .x \(x) .y \(y)")
        
        return CGPoint(x: x, y: y)
        
    }
    
    static func calCoordinateFromIndex( o: CGPoint, r: CGFloat, i: Int) -> CGPoint{
        let x = calCoordinateFromIndex(i).x * r + o.x
        let y = calCoordinateFromIndex(i).y * r + o.y
        return CGPoint(x: x, y: y)
        
    }

    
}