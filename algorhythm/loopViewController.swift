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
    
//    func addNewBonk
    
    @IBAction func onClickBonk(sender: UIButton) {
        bonkArray[0].play()
        
    }
    
    @IBAction func onClickBoingButton(sender: AnyObject) {
        //        var newPlayer : AVAudioPlayer! //this variable is created when the function starts and is killed when the function ends
        
        let newPath = NSBundle.mainBundle().pathForResource("String", ofType: "wav")
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
