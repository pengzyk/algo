//
//  Shape.swift
//  algorhythm
//
//  Created by Xu, Cheng on 11/20/15.
//  Copyright © 2015 sansserif. All rights reserved.
//
import UIKit
import Foundation
import AVFoundation

class Shape: NSObject, AVAudioPlayerDelegate{
    //http://makeapppie.com/2014/08/04/the-swift-swift-tutorial-why-do-we-need-delegates
    
    var timeArray = [AVAudioPlayer?](count:16, repeatedValue: nil)
    
    
    var imageView: UIView!
    var turnStep: Int!
    var fileName: String!
    var fileExtention: String!
    var filledSlots  = [Int]()

    
    override required init (){
        super.init()

    }
    
    func turn(step: Int)  {
        //shift the index by the number of steps
        for var index = 0 ; index < filledSlots.count ; ++index {
            var temp = (filledSlots[index]+step) % timeArray.count
            if (temp < 0 ){
                temp += timeArray.count //in case of CCW turns, temp would be a negative number 
            }
            filledSlots[index] = temp
            
        }
        
        //refresh the timeArray
       fillSlots ()
    }
    
    func fillSlots () {
        for var i=0 ; i < timeArray.count ; ++i {
            if filledSlots.contains( i ) {
                timeArray[i] = prepareAVAudioPlayer( fileName, fileType: fileExtention )
            }
            else {
                timeArray[i] = nil
            }
            
        }
        
    }
    
    
    func play(index: Int) -> Bool {
        //check each of the slot in ticSlots and play the audio, if occupied, play the sound.
        if ( self.timeArray[index] != nil) {
            self.timeArray[index]?.play()
           // print ("playing index \(index) fileName \(fileName) ")
            
            return true
        }
        return false
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