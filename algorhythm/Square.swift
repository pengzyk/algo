//
//  Square.swift
//  algorhythm
//
//  Created by Xu, Cheng on 11/19/15.
//  Copyright © 2015 sansserif. All rights reserved.
//

import Foundation
import AVFoundation

class Square: NSObject, AVAudioPlayerDelegate {
    
//    var firstName: String
//    var lastName: String
    
    //http://makeapppie.com/2014/08/04/the-swift-swift-tutorial-why-do-we-need-delegates
    var timeArray = [AVAudioPlayer?](count:16, repeatedValue: nil)

    override init() {

//        let mp3Path = NSBundle.mainBundle().pathForResource("WoodBonk", ofType: "wav")
//        let fileURL = NSURL.fileURLWithPath(mp3Path!)
//        let tempPlayer = try! AVAudioPlayer(contentsOfURL: fileURL)
//        tempPlayer.delegate = self
//        tempPlayer.prepareToPlay()
        
//        self.firstName = firstName
//        self.lastName = lastName
        
    }
    
    func test(){
        print(self.timeArray.count)
    }
    
    
    
}