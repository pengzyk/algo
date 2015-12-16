//
//  Octagon.swift
//  algorhythm
//
//  Created by Xu, Cheng on 12/14/15.
//  Copyright © 2015 sansserif. All rights reserved.
//
import UIKit
import Foundation
import AVFoundation


class Octagon : Shape{
    
    required init(){
        super.init()
        fileName = "just blaze tapsnare"
        fileExtention = "WAV"
        
    
        filledSlots = [1,3,5,7,9,11,13,15]
        
        fillSlots()
        
//        for var i=0 ; i < timeArray.count ; ++i {
//
//            
//            if filledSlots.contains( i) {
//                timeArray[i] = prepareAVAudioPlayer( "just blaze hisnare", fileType: "WAV")
//            }
//            
//        }
        
        //icon for shapes
        let imageName = "octagon.png"
        let image = UIImage(named: imageName)
        imageView = UIImageView(image: image!)
        imageView.tag = -1
        
                
    }
}

