//
//  Triangle.swift
//  algorhythm
//
//  Created by Xu, Cheng on 11/20/15.
//  Copyright © 2015 sansserif. All rights reserved.
//
import UIKit
import Foundation

//subclass of Shape
class Triangle : Shape {
     required init(){
        super.init()

        fileName = "just blaze hipsnare"
        fileExtention = "WAV"
        
        filledSlots = [0,5,11]
        initialFilledSlots = filledSlots ;
        fillSlots()
        
//        for var i=0 ; i < timeArray.count ; ++i {
//            if filledSlots.contains( i) {
//                timeArray[i] = prepareAVAudioPlayer( "just blaze exmple 38", fileType: "WAV")
//            }
//            
//        }
        
        
        //icon for shapes
        let imageName = "triangle.png"
        let image = UIImage(named: imageName)
        imageView = UIImageView(image: image!)
        imageView.tag = -1
 
    }
}