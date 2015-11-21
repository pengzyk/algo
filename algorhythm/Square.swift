//
//  Square.swift
//  algorhythm
//
//  Created by Xu, Cheng on 11/19/15.
//  Copyright © 2015 sansserif. All rights reserved.
//

import Foundation
import AVFoundation

protocol PlayerDelegate {
    
}

class Square :   NSObject, AVAudioPlayerDelegate {
    
    
    //http://makeapppie.com/2014/08/04/the-swift-swift-tutorial-why-do-we-need-delegates
    var timeArray = [AVAudioPlayer?](count:16, repeatedValue: nil)
//    var delegate : PlayerDelegate?
    
    override init() {
        
       super.init()
        
        let mp3Path = NSBundle.mainBundle().pathForResource("WoodBonk", ofType: "wav")
        let fileURL = NSURL.fileURLWithPath(mp3Path!)
        let tempPlayer = try! AVAudioPlayer(contentsOfURL: fileURL)
        tempPlayer.delegate = self
        tempPlayer.prepareToPlay()
        print("in init", tempPlayer)
        timeArray[0] = tempPlayer
          timeArray[1] = tempPlayer

    }
    
    func test(){
//        print(self.timeArray.count)
        print(" 0 \(self.timeArray[0]). 1 \(self.timeArray[1]) ")
        self.timeArray[0]?.play()

      
        
    }
    
    //load the audio files given the file names
    func prepareAVAudioPlayer(fileName: String, fileType: String) -> AVAudioPlayer {
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: fileType)
        let fileURL = NSURL.fileURLWithPath(path!)
        let tempPlayer = try! AVAudioPlayer(contentsOfURL: fileURL)
        tempPlayer.delegate = self
        tempPlayer.prepareToPlay()
        return tempPlayer
    }

    
    
}