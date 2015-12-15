//
//  Hexagon.swift
//  algorhythm
//
//  Created by Xu, Cheng on 12/14/15.
//  Copyright © 2015 sansserif. All rights reserved.
//


import UIKit
import Foundation
import AVFoundation


class Hexagon : Shape{
    
    required init(){
        super.init()
        fileName = "just blaze &ound10"
        fileExtention = "WAV"
        
        filledSlots = [1,4,7,9,12,15]
        
        fillSlots()

        
//        for var i=0 ; i < timeArray.count ; ++i {
//            if filledSlots.contains( i) {
//                timeArray[i] = prepareAVAudioPlayer( "just blaze &ound10", fileType: "WAV")
//            }
//            
//        }
        
        
        
        
        //icon for shapes
        let imageName = "hexagon.png"
        let image = UIImage(named: imageName)
        imageView = UIImageView(image: image!)
        imageView.tag = -1
        
         }
}
