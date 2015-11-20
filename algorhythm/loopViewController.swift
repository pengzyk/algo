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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("view did load")

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

    @IBAction func onClickSquare(sender: AnyObject) {
        
        
        let s = Square()
//        let s = Square(self)
        s.test()
        
    }
    @IBAction func onClickXButton(sender: AnyObject) {
        bonkArray.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


