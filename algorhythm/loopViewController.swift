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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("view did load")

        let mp3Path = NSBundle.mainBundle().pathForResource("Pong", ofType: "wav")

        let fileURL = NSURL.fileURLWithPath(mp3Path!)
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: fileURL)
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        

    
    }
    
    @IBAction func onClickPongButton(sender: UIButton) {
        
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
