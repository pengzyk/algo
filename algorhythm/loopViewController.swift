//
//  loopViewController.swift
//  algorhythm
//
//  Created by Xu, Cheng on 11/14/15.
//  Copyright © 2015 sansserif. All rights reserved.
//

import UIKit
import AVFoundation




class loopViewController: UIViewController , AVAudioPlayerDelegate {
    
    
    var audioPlayer : AVAudioPlayer!
    var newPlayer : AVAudioPlayer! //has to be declared here..
    var ticSlots = [AVAudioPlayer?](count:16, repeatedValue: nil)
    var ticCounter = 0
    
    //var shapes
    
    
    
    var squareInstance : Square!
    
    let INTERVAL = 75.0/60.0/16.0     //75  per min
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    //check each of the slot in ticSlots and play the audio, if occupied
    func tick(){
        
        squareInstance.play( ticCounter )
        
        //ticCounter loops through 0-15
        self.ticCounter++
        if(self.ticCounter >= self.ticSlots.count){
            self.ticCounter = 0
        }
        
        
    }
    @IBAction func onClickAddClassButton(sender: AnyObject) {
        //todo make this a mutable array
        squareInstance = Square ()
    }
    
    
    
    
    @IBAction func onClickPlayButton(sender: AnyObject) {
        
        //start a timer that loops through the array
        
        //TODO donnot allow this to be done twice!
        //TODO ADD A STOP
        NSTimer.scheduledTimerWithTimeInterval(INTERVAL, target: self, selector: "tick", userInfo: ticSlots as? AnyObject, repeats: true)
    }
    
    
    
    @IBAction func onClickXButton(sender: AnyObject) {
        
        
        
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


