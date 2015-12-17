//
//  Square.swift
//  algorhythm
//
//  Created by Xu, Cheng on 11/19/15.
//  Copyright © 2015 sansserif. All rights reserved.
//
import UIKit
import Foundation
import AVFoundation


class Square : Shape{
    
    required init(){
        super.init()
        fileName = "just blaze bksnare2"
        fileExtention = "WAV"
        
       
        filledSlots = [0,4,8,12]
        initialFilledSlots = filledSlots ;
        fillSlots()
//        
//        
//        for var i=0 ; i < timeArray.count ; ++i {
//                        if filledSlots.contains( i) {
//               timeArray[i] = prepareAVAudioPlayer( "just blaze fullkick", fileType: "WAV")
//                timeArray[i] = prepareAVAudioPlayer( fileName, fileType: fileExtention)
//            }
//            
//        }

        
        //icon for shapes
        let imageName = "square.png"
        let image = UIImage(named: imageName)
        imageView = UIImageView(image: image!)
        imageView.tag = -1
        
        
        
    }
}

