//
//  loopViewController.swift
//  algorhythm
//
//  Created by Xu, Cheng on 11/14/15.
//  Copyright © 2015 sansserif. All rights reserved.
//

import UIKit
import AVFoundation

//array of players
var bonkArray = [AVAudioPlayer]()




class loopViewController: UIViewController , AVAudioPlayerDelegate {
    
    
    var audioPlayer : AVAudioPlayer!
    var newPlayer : AVAudioPlayer! //has to be declared here..
    var timeSlots = [AVAudioPlayer?](count:16, repeatedValue: nil)
    
    var ticCounter = 0
    let INTERVAL = 75.0/60.0/16.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("timeSlots", timeSlots.count)
 print("in viewDidiLoad timeSlots", self.timeSlots)
        let mp3Path = NSBundle.mainBundle().pathForResource("Pong", ofType: "wav")

        let fileURL = NSURL.fileURLWithPath(mp3Path!)
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: fileURL)
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()

        
        //add one player to the array 
        
        bonkArray.append(audioPlayer)
        
//        tick()
    
    }
    
    func addNewBonk(){
        let mp3Path = NSBundle.mainBundle().pathForResource("WoodBonk", ofType: "wav")
        let fileURL = NSURL.fileURLWithPath(mp3Path!)
        let tempPlayer = try! AVAudioPlayer(contentsOfURL: fileURL)
        tempPlayer.delegate = self
        tempPlayer.prepareToPlay()
        bonkArray.append(tempPlayer)
        
    }
    
    
    
    @IBAction func onClickBonk(sender: UIButton) {
        addNewBonk()
        //todo add exception
        bonkArray.last!.play()
        
    }
  
    @IBAction func onClickSquare(sender: AnyObject) {

        let mp3Path = NSBundle.mainBundle().pathForResource("WoodBonk", ofType: "wav")
        let fileURL = NSURL.fileURLWithPath(mp3Path!)
        let tempPlayer = try! AVAudioPlayer(contentsOfURL: fileURL)
        tempPlayer.delegate = self
        tempPlayer.prepareToPlay()
        bonkArray.append(tempPlayer)
        
        timeSlots[0] = tempPlayer
        
    print("timeSlots", timeSlots.count)
        
    }
    //75  per min

    @IBAction func onClickPlayButton(sender: AnyObject) {
        print("play")
        //play in sequence
        print("in play timeSlots", self.timeSlots.count)// 16
        
        NSTimer.scheduledTimerWithTimeInterval(INTERVAL, target: self, selector: "tick", userInfo: timeSlots as? AnyObject, repeats: true)
    }

    func tick(){

        print("[tick] timeSlots size \(self.timeSlots.count). tickCounter \(self.ticCounter)")
        if ( self.timeSlots[self.ticCounter] != nil) {
            print("playing ", self.ticCounter) ;
            self.timeSlots[self.ticCounter]?.play()
//
        }
        self.ticCounter++
        if(self.ticCounter >= self.timeSlots.count){
            self.ticCounter = 0
        }
        
        
    }
    
    @IBAction func onClickBoingButton(sender: AnyObject) {
        //        var newPlayer : AVAudioPlayer! //this variable is created when the function starts and is killed when the function ends
        
        let newPath = NSBundle.mainBundle()
            .pathForResource("String", ofType: "wav")
        let newFileURL = NSURL.fileURLWithPath(newPath!)
        newPlayer = try! AVAudioPlayer(contentsOfURL: newFileURL)
        newPlayer.delegate = self
        newPlayer.prepareToPlay()
        print("boing ")
        newPlayer.play()
        
        
    }
    
    @IBAction func onClickPongButton(sender: UIButton) {
        print("pong ")
        
        audioPlayer.play()
        
    }

    
    
    @IBAction func onClickXButton(sender: AnyObject) {
        bonkArray.removeAll()
      //  timeSlots = []
        //print(timeSlots.count)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


