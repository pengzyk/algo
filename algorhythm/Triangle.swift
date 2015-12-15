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
     override init(){
        super.init()

        super.timeArray[0] =  super . prepareAVAudioPlayer("just blaze exmple 38", fileType: "WAV")
        super.timeArray[5] =  super . prepareAVAudioPlayer("just blaze exmple 38", fileType: "WAV")
        super.timeArray[11] =  super . prepareAVAudioPlayer("just blaze exmple 38", fileType: "WAV")

//        print ("triangle init: super.timeArray[1]\(super.timeArray[1])")
        
        //icon for shapes
        let imageName = "triangle.png"
        let image = UIImage(named: imageName)
        imageView = UIImageView(image: image!)
        imageView.tag = -1
 
    }
}