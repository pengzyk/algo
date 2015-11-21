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
    var timer      = NSTimer()
    
    @IBOutlet weak var playButton: UIButton!
    //var shapes
    
    
    
    var squareInstance : Square!
    var triangleInstance : Triangle!
    
    let TIMER_INTERVAL = 75.0/60.0/16.0     //75  per min
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    func tick(){
       // print( self.ticCounter)
        if(self.squareInstance != nil ){
            self.squareInstance.play( self.ticCounter )
            
        }
        if(self.triangleInstance != nil ){
            self.triangleInstance.play( self.ticCounter )
            
        }
        
        //ticCounter loops through 0-15
        self.ticCounter++
        if(self.ticCounter >= self.ticSlots.count){
            self.ticCounter = 0
        }
        
        
    }
    
    @IBAction func onAddTrianbleButton(sender: AnyObject) {
        triangleInstance = Triangle()
        
    }
    
    @IBAction func onClickAddSquareButton(sender: AnyObject) {
        //todo make this a mutable array
        squareInstance = Square ()
        
    }
    
    //you cant stop the timer if it's already stopped because your app will crash.
    @IBAction func onClickPlayButton(sender: AnyObject) {
        
        //if currently running
        if ( timer.valid){
                timer.invalidate()
            playButton.setTitle("PLAY", forState: UIControlState.Normal)
            print ("stop timer" )
        } //if currently paused, clicking this button will start the timer
        
        else {
              //create the timer & add the timer automatically to the NSRunLoop
           timer = NSTimer.scheduledTimerWithTimeInterval(TIMER_INTERVAL, target: self, selector: "tick", userInfo: ticSlots as? AnyObject, repeats: true)
            playButton.setTitle("PAUSE", forState: UIControlState.Normal)
            print ("start timer" )
        }
        
//        print("timer" , timer.valid)
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


