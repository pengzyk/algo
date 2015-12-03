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
    
    
    // basic structure
    var audioPlayer : AVAudioPlayer!
    var newPlayer : AVAudioPlayer! //has to be declared here..
    var ticSlots = [AVAudioPlayer?](count:16, repeatedValue: nil)
    var ticCounter = 0
    var timer      = NSTimer()
    
    
    // graphical UI
    @IBOutlet weak var playButton: UIButton!

    var shapes = [Shape]()
    
//    
//    var squareInstance : Square!
//    var triangleInstance : Triangle!
    
    //BPM 75 : 60.0/75.0/4.0
    let TIMER_INTERVAL =  60.0/300.0 // loat(60) / Float(75)
//    var LOOP_PERIOD : Float!
    let LOOP_PERIOD = 60.0/300.0 * 16
    
    //player loop
    @IBOutlet weak var playerUIView : UIView!
    @IBOutlet weak var playerImage: UIImageView!
    //initialize path bounds
    let circleStartAngle = CGFloat(270.01 * M_PI/180)
    let circleEndAngle = CGFloat(270 * M_PI/180)
    let circleBounds = CGRectMake(20, 50, 280, 280)
    let circlePath = UIBezierPath()
    //initialize animnation
    let anim = CAKeyframeAnimation(keyPath: "position")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //PLAYER LOOP 
//        LOOP_PERIOD = TIMER_INTERVAL * 16.0
        //initialize view size and position
        playerUIView.frame = CGRect(x: 160, y: 300, width: 30, height: 30)
        playerUIView.alpha = 0
        playerImage.alpha = 0.5
        
        //create path for player dot
        circlePath.addArcWithCenter(CGPointMake(CGRectGetMidX(circleBounds), CGRectGetMidY(circleBounds)),
            radius: CGRectGetWidth(circleBounds)/2,
            startAngle: circleStartAngle,
            endAngle: circleEndAngle,
            clockwise: true)
        

        
        
        
    }
    
    
    
    
    
    func tick(){
       // print( self.ticCounter)

        //loop through shapes
        var ifAnimate = false
        
        if(shapes.count > 0 ){
            for shape in shapes {
                //ifAnimate turns to true, if any one shape has a note in the tic
                ifAnimate = ifAnimate || shape.play(self.ticCounter)
            }
            
        }
        
        if(ifAnimate){
            animatePlayer()
        }
        
        //ticCounter loops through 0-15
        self.ticCounter++
        if(self.ticCounter >= self.ticSlots.count){
            self.ticCounter = 0
        }
        
        
    }
    
    @IBAction func onAddTrianbleButton(sender: AnyObject) {
        shapes.append(Triangle())
        
    }
    
    @IBAction func onClickAddSquareButton(sender: AnyObject) {
        shapes.append(Square())
        
    }
    
    //you cant stop the timer if it's already stopped because your app will crash.
    @IBAction func onClickPlayButton(sender: AnyObject) {
        
        //if currently running
        if ( timer.valid){
                timer.invalidate()
            playButton.setTitle("PLAY", forState: UIControlState.Normal)
            print ("stop timer" )
            
            //PLAYER LOOP 
            playerUIView.layer.removeAllAnimations()
            playerUIView.alpha = 0
            
            
        } //if currently paused, clicking this button will start the timer
        
        else {
              //create the timer & add the timer automatically to the NSRunLoop
           timer = NSTimer.scheduledTimerWithTimeInterval(TIMER_INTERVAL, target: self, selector: "tick", userInfo: ticSlots as? AnyObject, repeats: true)
            playButton.setTitle("PAUSE", forState: UIControlState.Normal)
            print ("start timer" )
            
            
            //PLAYER LOOP 
            playerUIView.alpha = 1
            //choose animation path
            anim.path = circlePath.CGPath
            
            //set some more parameters for the animation
            anim.repeatCount = Float.infinity
            anim.duration = LOOP_PERIOD
            
            //add animation to square layer
            playerUIView.layer.addAnimation(anim, forKey: "animate position along path")
        }
        
//        print("timer" , timer.valid)
    }
    
    
    
    @IBAction func onClickXButton(sender: AnyObject) {
        
        
        
    }
    
    func animatePlayer() {
        
        
        //animate dot player when a beat is there - this should be in an if statement
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options:[] , animations: { () -> Void in
            self.playerUIView.transform = CGAffineTransformMakeScale(2, 2)
            self.playerImage.alpha = 0.7
            }, completion: { (Bool) -> Void in
        })
        
        UIView.animateWithDuration(0.1) { () -> Void in
            self.playerUIView.transform = CGAffineTransformMakeScale(1, 1)
            self.playerImage.alpha = 0.5
            
        }

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


