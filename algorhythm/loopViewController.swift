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
    var ticSlots = [AVAudioPlayer?](count:16, repeatedValue: nil)
    var ticCounter = 0
    
    let INTERVAL = 75.0/60.0/16.0     //75  per min
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mp3Path = NSBundle.mainBundle().pathForResource("Pong", ofType: "wav")
        let fileURL = NSURL.fileURLWithPath(mp3Path!)
        audioPlayer = try! AVAudioPlayer(contentsOfURL: fileURL)
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()

        
        //add one player to the array
        bonkArray.append(audioPlayer)
        
    
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
        //add drum beats at 4,8,12,16 positions (a square shape!)
        ticSlots[0] = prepareAVAudioPlayer( "WoodBonk", fileType: "wav")
        ticSlots[4] = prepareAVAudioPlayer( "WoodBonk", fileType: "wav")
        ticSlots[8] = prepareAVAudioPlayer( "WoodBonk", fileType: "wav")
        ticSlots[12] = prepareAVAudioPlayer( "WoodBonk", fileType: "wav")
        
    }
    

    @IBAction func onClickPlayButton(sender: AnyObject) {
//        print("play")
//        print("in play timeSlots", self.timeSlots.count)// 16
        
        //start a timer that loops through the array
        NSTimer.scheduledTimerWithTimeInterval(INTERVAL, target: self, selector: "tick", userInfo: ticSlots as? AnyObject, repeats: true)
    }

    //check each of the slot in ticSlots and play the audio, if occupied
    func tick(){
//        print("[tick] timeSlots size \(self.timeSlots.count). tickCounter \(self.ticCounter)")
        if ( self.ticSlots[self.ticCounter] != nil) {
            print("playing at slot ", self.ticCounter) ;
            self.ticSlots[self.ticCounter]?.play()
        }
        
        //ticCounter loops through 0-15
        self.ticCounter++
        if(self.ticCounter >= self.ticSlots.count){
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
        
        //todo: return ticSlots to array of 16 nils
        
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


