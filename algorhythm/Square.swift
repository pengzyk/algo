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
    
    override init(){
        super.init()
        
        timeArray[0] = prepareAVAudioPlayer( "just blaze fullkick", fileType: "WAV")
        timeArray[4] = prepareAVAudioPlayer( "just blaze fullkick", fileType: "WAV")
        timeArray[8] = prepareAVAudioPlayer( "just blaze fullkick", fileType: "WAV")
        timeArray[12] = prepareAVAudioPlayer( "just blaze fullkick", fileType: "WAV")
        
        //icon for shapes
        let imageName = "square.png"
        let image = UIImage(named: imageName)
        imageView = UIImageView(image: image!)
        imageView.tag = -1
        
        
        
    }
}


//class Square :   NSObject, AVAudioPlayerDelegate {
//    
//    
//       var timeArray = [AVAudioPlayer?](count:16, repeatedValue: nil)
//    //    var delegate : PlayerDelegate?
//    
//    override init() {
//        super.init()
//        
//        timeArray[0] = prepareAVAudioPlayer( "WoodBonk", fileType: "wav")
//        timeArray[4] = prepareAVAudioPlayer( "WoodBonk", fileType: "wav")
//        timeArray[8] = prepareAVAudioPlayer( "WoodBonk", fileType: "wav")
//        timeArray[12] = prepareAVAudioPlayer( "WoodBonk", fileType: "wav")
//        
//        print("square initialized")
//    }
//    
//   
//    
//    
//    func play(index: Int){
//        //check each of the slot in ticSlots and play the audio, if occupied, play the sound.
//        if ( self.timeArray[index] != nil) {
//            self.timeArray[index]?.play()
//        }
//        
//    }
//    
//    
//    //load the audio files given the file names
//    func prepareAVAudioPlayer(fileName: String, fileType: String) -> AVAudioPlayer {
//        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: fileType)
//        let fileURL = NSURL.fileURLWithPath(path!)
//        let tempPlayer = try! AVAudioPlayer(contentsOfURL: fileURL)
//        tempPlayer.delegate = self
//        tempPlayer.prepareToPlay()
//        return tempPlayer
//    }
//    
//    
//    func test(){
//        //        print(self.timeArray.count)
//        //        print(" 0 \(self.timeArray[0]). 1 \(self.timeArray[1]) ")
//        //        self.timeArray[8]?.play()
//        
//    }
//    
//    
//}