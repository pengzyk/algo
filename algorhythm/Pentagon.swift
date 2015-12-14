//
//  Pentagon.swift
//  algorhythm
//
//  Created by Xu, Cheng on 12/14/15.
//  Copyright © 2015 sansserif. All rights reserved.
//


import UIKit
import Foundation
import AVFoundation


class Pentagon : Shape{
    
    override init(){
        super.init()
        
        timeArray[0] = prepareAVAudioPlayer( "just blaze &ound10", fileType: "WAV")
        timeArray[3] = prepareAVAudioPlayer( "just blaze &ound10", fileType: "WAV")
        timeArray[6] = prepareAVAudioPlayer( "just blaze &ound10", fileType: "WAV")
        timeArray[10] = prepareAVAudioPlayer( "just blaze &ound10", fileType: "WAV")
        timeArray[13] = prepareAVAudioPlayer( "just blaze &ound10", fileType: "WAV")

        
        //icon for shapes
        let imageName = "pentagon.png"
        let image = UIImage(named: imageName)
        imageView = UIImageView(image: image!)
        imageView.tag = -1
        
        
        print("square initialized")
        
        
    }
}
