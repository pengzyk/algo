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

        super.timeArray[2] =  super . prepareAVAudioPlayer("WoodBonk", fileType: "wav")
        super.timeArray[6] =  super . prepareAVAudioPlayer("WoodBonk", fileType: "wav")
        super.timeArray[10] =  super . prepareAVAudioPlayer("WoodBonk", fileType: "wav")

//        print ("triangle init: super.timeArray[1]\(super.timeArray[1])")
        
        //icon for shapes
        let imageName = "triangle.png"
        let image = UIImage(named: imageName)
        imageView = UIImageView(image: image!)
        imageView.tag = -1 
        
        
         print ("triangle init")
    }
}