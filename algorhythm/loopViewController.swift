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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("view did load")

        let mp3Path = NSBundle.mainBundle().pathForResource("Pong", ofType: "wav")

        let fileURL = NSURL.fileURLWithPath(mp3Path!)
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: fileURL)
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.play()

        
//               let newPath = NSBundle.mainBundle().pathForResource("Pong", ofType: "wav")
//        let newFileURL = NSURL.fileURLWithPath(newPath!)
//        newPlayer = try! AVAudioPlayer(contentsOfURL: newFileURL)
//        newPlayer.delegate = self
       // newPlayer.prepareToPlay()
       
        
        

    
    }
    
    @IBAction func onClickPongButton(sender: UIButton) {
        
        //audioPlayer.play()
        
//        var newPlayer : AVAudioPlayer!

        let newPath = NSBundle.mainBundle().pathForResource("Pong", ofType: "wav")
        let newFileURL = NSURL.fileURLWithPath(newPath!)
        newPlayer = try! AVAudioPlayer(contentsOfURL: newFileURL)
        newPlayer.delegate = self
        newPlayer.prepareToPlay()
       print("new player ")
        newPlayer.play()

        
        
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
