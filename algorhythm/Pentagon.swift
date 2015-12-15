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
        
        for var i=0 ; i < timeArray.count ; ++i {
            if (i == 0 || i == 3 || i == 6 || i == 10 || i == 13 ){
                timeArray[i] = prepareAVAudioPlayer( "just blaze &ound10", fileType: "WAV")
            }
        }
        
        //icon for shapes
        let imageName = "pentagon.png"
        let image = UIImage(named: imageName)
        imageView = UIImageView(image: image!)
        imageView.tag = -1
        
        

        
        
    }
}
