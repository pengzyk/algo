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
    
    override init(){
        super.init()
        for var i=0 ; i < timeArray.count ; ++i {
            if (i == 1 || i == 3 || i == 5 || i == 7 || i == 9 || i == 11 || i == 13 || i == 15 ){
                timeArray[i] = prepareAVAudioPlayer( "just blaze hisnare", fileType: "WAV")
            }
        }
        
        //icon for shapes
        let imageName = "octagon.png"
        let image = UIImage(named: imageName)
        imageView = UIImageView(image: image!)
        imageView.tag = -1
        
                
    }
}

